//
//  DatabaseManager.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 09.03.2023.
//

import FirebaseFirestore
import Foundation

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init() {}
    
    let database = Firestore.firestore()
    
    func findUser(with email: String, completion: @escaping (String, String) -> Void) {
        let ref = database.collection("students").whereField("email", isEqualTo: email)
        
        
        ref.getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print("SNAPSHOT WASN'T FOUND")
                return
            }
            
            let name = snapshot.documents.first?.get("name") as? String ?? ""
            let surname = snapshot.documents.first?.get("surname") as? String ?? ""
            
            completion(name, surname)
        }
        
    }
    
    func queryAmountOfClasses(subjectCode code: String, completion: @escaping (Int) -> ()) {
        let fullname = (UserDefaults.standard.value(forKey: "name") as? String ?? "") + " " +  (UserDefaults.standard.value(forKey: "surname") as? String ?? "")
        let docID = DatabaseManager.shared.database.collection("students").document(fullname)
        var totalAttendanceCount = 0
        var amountOfHours = 0
        docID.getDocument {snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                return
            }
            
            let studentID = snapshot.get("id") as? String ?? ""
            
            let ref = DatabaseManager.shared.database.collection("subjects")
                .whereField("code", isGreaterThan: "\(code)")
                .whereField("code", isLessThan: "\(code)u{f8ff}]")
                .whereField("enrolledStudents", arrayContains: studentID)
            ref.getDocuments { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    print("queryAmountOfClasses: \(error)")
                    return
                }
                
                for doc in snapshot.documents {
                    totalAttendanceCount += (doc.get("dates") as? [String])?.count ?? 15
                    
                    let startTime = (doc.get("startTime") as? String ?? "")
                    let endTime = (doc.get("endTime") as? String ?? "")
                    
                    let startHour = Int(String(startTime.prefix(2))) ?? 0
                    let endHour = Int(String(endTime.prefix(2))) ?? 0
                    
                    amountOfHours = endHour - startHour
                }
                completion(totalAttendanceCount * (amountOfHours + 1))
                totalAttendanceCount = 0
            }
        }
    }
    
    func querySubjects(name: String, surname: String, completion: @escaping ([Subject]) -> Void) {
        var subjects: [Subject] = []
        let docID = DatabaseManager.shared.database.collection("students").document("\(name) \(surname)")
        let dispatchGroup = DispatchGroup()
        
        docID.getDocument { [weak self] snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                return
            }
            
            guard let studentID = snapshot.get("id") else { return }
            
            
            DatabaseManager.shared.database.collection("subjects")
                .whereField("enrolledStudents", arrayContains: studentID)
                .order(by: "id")
                .getDocuments  { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            let code = document.get("code") as? String ?? ""
                            let name = document.get("name") as? String ?? ""
                            
                            dispatchGroup.enter()
                            self?.queryAmountOfClasses(subjectCode: String(code.prefix(6))) { total in
                                self?.queryAttendance(
                                    name: UserDefaults.standard.value(forKey: "name") as? String ?? "",
                                    surname: UserDefaults.standard.value(forKey: "surname") as? String ?? "",
                                    for: String(code.prefix(6)),
                                    completion: { absence in
                                        guard let contains = self?.checkIfContains(subjects: subjects,name: name) else { return }
                                    
                                    if !contains {
                                        subjects.append(
                                            Subject(
                                                subjectCode: code,
                                                subjectName: name,
                                                totalAttendanceCount: total,
                                                absenceCount: absence)
                                        )
                                        subjects.sort(by: { s1, s2 in
                                            s1.subjectCode < s2.subjectCode
                                        })
                                    }
                                    dispatchGroup.leave()
                                })
                            }
                        }
                        dispatchGroup.notify(queue: .main) { // Call the completion block when all tasks have finished
                            completion(subjects)
                        }
                    }
                }
        }
        
    }
    
    
    func queryAttendance(name: String, surname: String, for subject: String, completion: @escaping (Int) -> Void) {
        let docID = DatabaseManager.shared.database.collection("students")
            .document("\(name) \(surname)")
        var absenceCount = 0

        docID
            .getDocument { [weak self] snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                return
            }

            guard let studentID = snapshot.get("id") else {
                return
            }
                
            DatabaseManager.shared.database.collection("attendance")
                .whereField("code", isGreaterThanOrEqualTo: subject)
                .whereField("code", isLessThan: "\(subject)u{f8ff}]")
                .getDocuments { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    print("Error: \(error)")
                    return
                }

                for document in snapshot.documents {
                    let dates = document.data().keys //dates 15.03.2023...
                    for key in dates {
                        let value = document.data()[key] // returns array

                        if let arr = value as? [Any]{
                            if let dict = arr[0] as? [String: Any] {
                                guard let attendances = dict["\(studentID)"] as? [Int] else { continue }
                                for attendance in attendances {
                                    if(attendance == 0) {
                                        absenceCount += 1;
                                    }
                                }
                                

                            } else {
                                print("Could not cast to [String: Any]")
                            }
                        } else {
                            print("Could not cast to [Any]")
                        }
                    }
                }
                    completion(absenceCount ?? 0)
            }

        }
    }
    
    
    func checkIfContains(subjects: [Subject], name: String) -> Bool {
        var contains = false
        
        for i in 0..<subjects.count {
            if subjects[i].subjectName == name {
                contains = true
            }
        }
        
        return contains
    }
//    
    func loadAttendance(completion: @escaping ([Subject]) -> Void) {
        let docRef = DatabaseManager.shared.database.collection("attendance")
        
        
        var listener = docRef
            .addSnapshotListener {[weak self] snapshot, error in
                guard let _ = snapshot, error == nil else {
                    return
                }
                
                DatabaseManager.shared.querySubjects(
                    name: UserDefaults.standard.value(forKey: "name") as? String ?? "",
                    surname: UserDefaults.standard.value(forKey: "surname") as? String ?? "") { subjects in
                        completion(subjects)
                    }
            }
        
    }
    
    func loadAttendanceStatusForParticularDate(dataString: String, fullCode: String, completion: @escaping ( [String: Any] ) -> Void) {
        let documentReference = DatabaseManager.shared.database.collection("attendance").document(fullCode)
        documentReference.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let attendance = data?[dataString] as? [[String: Any]] {
                    let studentID = UserDefaults.standard.value(forKey: "id") as? String ?? ""
                    let attStatus = attendance[0][studentID] as! [Int]
                    var attended: [Int] = []
                    for attendance in attStatus {
                        if attendance == 1 {
                            attended.append(1)
                        } else {
                            attended.append(0)
                        }
                    }
                    let dict = [
                        "needToAttend": attStatus.count,
                        "attended": attended
                    ]
                    completion(dict)
                } else {
                    print("Unfortunately, it goes to else block")
                    completion([:])
                }
                
            } else {
                completion([:])
                print("Document does not exist")
            }
        }
        
    }
    
    
    
    func getTokens(for date: String, fullCode: String, completion: @escaping ([String]?) -> Void) {
        let documentReference = DatabaseManager.shared.database.collection("attendance").document(fullCode)
        documentReference.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let tokens = data?["tokens"] as? [String: Any] {
                    let studentID = UserDefaults.standard.value(forKey: "id") as? String ?? ""
                    let tokensForDate = tokens[date] as? [String]
                    
                    completion(tokensForDate)
                } else {
                    print("Unfortunately, it goes to else block")
                    completion(nil)
                }
                
            } else {
                completion(nil)
                print("Document does not exist")
            }
        }
    }
    
    func updateAttendanceStatus(
        date: String,
        studentID: String,
        fullSubjectCode: String,
        index: Int,
        completion: @escaping (Bool) -> Void) {
        let docRef = DatabaseManager.shared.database.collection("attendance").document(fullSubjectCode)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var attendanceData = document.data() ?? [:]
                if var dataForDate = attendanceData[date] as? [[String: Any]], var studentData = dataForDate.first(where: { $0[studentID] != nil }) {
                    guard var attStatusesOfStudent = studentData[studentID] as? [Bool] else {
                        completion(false)
                        return
                    }
               
                    attStatusesOfStudent[index] = true // update the value here
                    studentData[studentID] = attStatusesOfStudent
                    print("attStatusesOfStudent \(attStatusesOfStudent)")
                    dataForDate = [studentData]
                    attendanceData[date] = dataForDate
                    docRef.setData(attendanceData, merge: true) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                            completion(false)
                        } else {
                            print("Document successfully updated")
                            completion(true)
                        }
                    }
                }
            } else {
                print("Document does not exist")
                completion(false)
            }
        }

    }
    
    func sendMessage(
        fullSubjectCode: String,
        dict: [String: Any],
        completion: @escaping (Bool) -> Void) {
            DatabaseManager.shared.database
                .collection("message")
                .document(fullSubjectCode).setData(dict as [String : Any]) { error in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
        }
    
}

