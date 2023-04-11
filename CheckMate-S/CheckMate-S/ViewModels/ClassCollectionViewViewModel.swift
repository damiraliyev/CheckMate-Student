//
//  ClassCollectionViewViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 22.03.2023.
//

import Foundation

final class ClassCollectionViewViewModel: ClassCollectionViewViewModelType {
    
    private var classes = [SubjectClass]()
    
    var needToAttend = 0
    var attended: [Int] = [0,0]
    
    func loadAttendanceStatusesForDate(date: String, completion: @escaping () -> ()) {
        DatabaseManager.shared.loadAttendanceStatusForParticularDate(dataString: date) { [weak self] dict in
            print("Fetched \(dict)")
            if dict.count == 0 {
                print("There is no information for this particular date.")
            } else {
                self?.needToAttend = dict["needToAttend"] as? Int ?? 0
                print("self?.attende", dict["attended"])
                self?.attended = dict["attended"] as? [Int] ?? [0]
            }
            completion()
        }
    }
    

    
    func queryClassForDate(
        studentID: String,
        subjectCode: String,
        date: String,
        completion: @escaping () -> Void
       ) {
           print("APPROPRIATE SUBJECT", subjectCode)
           print(date)
           classes = []
           
           loadAttendanceStatusesForDate(date: date) {
               
                DatabaseManager.shared.database.collection("subjects")
                    .whereField("code", isGreaterThanOrEqualTo: subjectCode)
                    .whereField("code", isLessThan: subjectCode + "\u{f8ff}]")
                    .whereField("dates", arrayContains: date)
                    .getDocuments { [weak self] snapshot, error in
                    guard let snapshot = snapshot, error == nil else {
                        print("CAN NOT FIND SUBJECT WITH SUCH CODE")
                        print(error?.localizedDescription)
                        return
                    }
                        
                        var code = ""
                        var name = ""
                        var startTime = ""
                        var endTime = ""
                        print("STUDENT ID", studentID)
                        if snapshot.documents.count > 0 {
                            for document in snapshot.documents {
                                if (document["enrolledStudents"] as! [String]).contains(studentID) {
                                    code  = String((document["code"] as? String)?.suffix(6) ?? "")
                                    name = String((document["name"] as? String) ?? "")
                                    startTime = (document["startTime"] as? String ?? "")
                                    endTime = (document["endTime"] as? String ?? "")
                                    
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
                                         subjectCode: code,
                                         subjectName: name,
                                         startTime: startTime,
                                         endTime: firstClassEnd,
                                         needToAttend: 1,
                                         attended: self?.attended[0] ?? 0
                                        )
                                        
                                        let subjectSecondClass = SubjectClass(
                                         subjectCode: code,
                                         subjectName: name,
                                         startTime: secondClassStart,
                                         endTime: endTime,
                                         needToAttend: 1,
                                         attended: self?.attended[1] ?? 0
                                        )
                                        
                                        self?.classes.append(subjectFirstClass)
                                        self?.classes.append(subjectSecondClass)
                                    } else {
                                        print("Why is it crashing?", self?.attended)
                                        let subjectClass = SubjectClass(
                                         subjectCode: code,
                                         subjectName: name,
                                         startTime: startTime,
                                         endTime: endTime,
                                         needToAttend: 1,
                                         attended: self?.attended[0] ?? 0
                                        )
                                            self?.classes.append(subjectClass)
                                    }
                                    
                                    
                                }
                                
                            }
                       
                        }
                        
                        completion()
                    
                }
                
           }
          
       }
    
   
    
    func numberOfRows() -> Int {
        classes.count
    }
    
    func classCellViewModel(for indexPath: IndexPath) -> ClassCollectionViewCellViewModelType? {
        let subjectClass = classes[indexPath.row]
        
        return ClassCollectionViewCellViewModel(subjectClass: subjectClass)
        
    }
    
    
}
