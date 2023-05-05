//
//  ClassCollectionViewViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 22.03.2023.
//

import Foundation

final class ClassCollectionViewViewModel: ClassCollectionViewViewModelType {
    
    var classes = [SubjectClass]()
    
    var tokens: [String]? = nil
    
    var isValidToken: Bool = false
    
    var selectedIndexPath: IndexPath?
    
    var needToAttend = 0
    var attended: [Int] = []
    var attendedDict: [String : [Int]] = [:]
    
    func loadAttendanceStatusesForDate(date: String, fullSubjectCode: String, completion: @escaping ([Int]) -> ()) {
        DatabaseManager.shared.loadAttendanceStatusForParticularDate(dataString: date, fullCode: fullSubjectCode) { [weak self] dict in
            print("Fetched \(dict)")
            if dict.count == 0 {
                print("There is no information for this particular date.")
                self?.attended = [0, 0]
                completion(self?.attended ?? [0,0])
            } else {
                self?.needToAttend = dict["needToAttend"] as? Int ?? 0
                self?.attended = []
                
                let attendedArr = dict["attended"] as? [Int] ?? [0]
                for attend in attendedArr {
                    self?.attended.append(attend)
                    self?.attendedDict[String(fullSubjectCode.suffix(6))] = self?.attended
                }
                completion(self?.attended ?? [0, 0])
            }

        }

    }
    

    #warning("full subject code here needs to be deleted")
    func queryClassForDate(
        studentID: String,
        fullSubjectCode: String,
        subjectCode: String,
        date: String,
        completion: @escaping () -> Void
       ) {
           classes = []
           var fullCodes: [String] = []
           let dispatchGroup = DispatchGroup()
               
                DatabaseManager.shared.database.collection("subjects")
                    .whereField("code", isGreaterThanOrEqualTo: subjectCode)
                    .whereField("code", isLessThan: subjectCode + "\u{f8ff}]")
                    .whereField("dates", arrayContains: date)
                    .getDocuments { [weak self] snapshot, error in
                    guard let snapshot = snapshot, error == nil else {
                        print("CAN NOT FIND SUBJECT WITH SUCH CODE")
                        print(error?.localizedDescription)
                        completion()
                        return
                    }
                    
                        if snapshot.documents.isEmpty {
                            completion() // Call completion if there are no matching documents
                            return
                        }
                        
                        var code = ""
                        var name = ""
                        var startTime = ""
                        var endTime = ""
                        #warning("adding teacher id")
                        var teacherID = ""
                        print("STUDENT ID", studentID)
                        if snapshot.documents.count > 0 {
                            for document in snapshot.documents {
                                if (document["enrolledStudents"] as! [String]).contains(studentID) {
                                    dispatchGroup.enter()
                                    self?.loadAttendanceStatusesForDate(date: date, fullSubjectCode: (document["code"] as? String) ?? "No code", completion: { attendedValues in
                                        code = String((document["code"] as? String)?.suffix(6) ?? "")
                                        fullCodes.append((document["code"] as? String) ?? "No code")
                                        name = String((document["name"] as? String) ?? "")
                                        startTime = (document["startTime"] as? String ?? "")
                                        endTime = (document["endTime"] as? String ?? "")
                                        teacherID = (document["teacherID"] as? String ?? "")
                                        let fullCode = String((document["code"] as? String ?? "No code"))
                                        let startHour = Int(String(startTime.prefix(2))) ?? 0
                                        let endHour = Int(String(endTime.prefix(2))) ?? 0
  
                                        if endHour - startHour >= 1 {
                                            
                                            var firstClassEnd = String(startHour) + ":50"
                                            if String(startHour).count == 1 {
                                                firstClassEnd = "0\(startHour):50"
                                            }
                                            
                                            var secondClassStart = String(startHour + 1) + ":00"
                                            if String(startHour + 1).count == 1 {
                                                secondClassStart = "0\(startHour + 1):00"
                                            }
                                            
                                            let subjectFirstClass = SubjectClass(
                                                teacherID: teacherID,
                                                fullSubjectCode: fullCode,
                                                shortSubjectCode: code,
                                                subjectName: name,
                                                startTime: startTime,
                                                endTime: firstClassEnd,
                                                needToAttend: 1,
                                                attended: attendedValues[0]
                                            )
                                            
                                            let subjectSecondClass = SubjectClass(
                                                teacherID: teacherID,
                                                fullSubjectCode: fullCode,
                                                shortSubjectCode: code,
                                                subjectName: name,
                                                startTime: secondClassStart,
                                                endTime: endTime,
                                                needToAttend: 1,
                                                attended: attendedValues[1]
                                            )
                                            
                                            self?.classes.append(subjectFirstClass)
                                            self?.classes.append(subjectSecondClass)
                                        } else {
                                            let subjectClass = SubjectClass(
                                                teacherID: teacherID,
                                                fullSubjectCode: fullCode,
                                                shortSubjectCode: code,
                                                subjectName: name,
                                                startTime: startTime,
                                                endTime: endTime,
                                                needToAttend: 1,
                                                attended: attendedValues[0]
                                            )
                                                self?.classes.append(subjectClass)
                                        }
                                        dispatchGroup.leave()
                                        
                                    })
                                   
                                }
                                
                            }
                            dispatchGroup.notify(queue: .main) {
                                completion() // Call completion when all the loadAttendanceStatusesForDate calls are finished
                            }
                            
                       
                        }
                }
                
//           }
          
       }
    
   
    
    func numberOfRows() -> Int {
        classes.count
    }
    
    func classCellViewModel(for indexPath: IndexPath) -> ClassCollectionViewCellViewModelType? {
        let subjectClass = classes[indexPath.row]
        return ClassCollectionViewCellViewModel(subjectClass: subjectClass)
        
    }
    
    
    func selectedClass() -> SubjectClass? {
        guard let selectedIndexPath = selectedIndexPath else {
            return nil
        }
        print(selectedIndexPath.row)
        print("CLASSES IN VIEW MODEL WHY ONLY 07-P \(classes)")
        return classes[selectedIndexPath.row]
    }
    
    func getTokensForClass(
        date: String,
        fullSubjectCode: String,
        completion: @escaping () -> Void
    ) {
        DatabaseManager.shared.getTokens(for: date, fullCode: fullSubjectCode) { tokens in
            self.tokens = tokens
            completion()
        }
    }
    
    var enteredToken: String?
    
    func checkToken(fullSubjectCode: String) -> Bool {
        guard let tokens = tokens, let enteredToken = enteredToken else {
            return false
        }
        
        guard let selectedIndexPath = selectedIndexPath else {
            return false
        }
        
        var counter = 0
        for class_ in classes {
            if class_.fullSubjectCode == fullSubjectCode {
                break
            } else {
                counter += 1
            }
        }
        
        let indexOfClassInArray = selectedIndexPath.row - counter
        
        
        if tokens.contains(enteredToken) {
            for i in stride(from: 0, to: tokens.count, by: 1) {
                if tokens[i] == enteredToken {
                    if i == indexOfClassInArray {
                        isValidToken = true
                        return true
                    }
                }
            }
            isValidToken = false
            return false
        } else {
            isValidToken = false
            return false
        }
    }
    
    func updateAttendanceStatus(
        date: String,
        studentID: String,
        fullSubjectCode: String,
        completion: @escaping (Bool) -> Void) {
            guard let selectedIndexPath = selectedIndexPath else {
                return
            }
            var counter = 0
            for class_ in classes {
                if class_.fullSubjectCode == fullSubjectCode {
                    break
                } else {
                    counter += 1
                }
            }
            DatabaseManager.shared.updateAttendanceStatus(
                date: date,
                studentID: studentID,
                fullSubjectCode: fullSubjectCode,
                index: selectedIndexPath.row - counter) {[weak self] hasUpdated in
                    if hasUpdated {
                        guard let enteredToken = self?.enteredToken, var tokens = self?.tokens else {
                            print("No entered token or tokens")
                            return
                        }
                        self?.classes[selectedIndexPath.row].attended = 1
                        
                    }
                    completion(hasUpdated)
                }
        }
    
    
}
