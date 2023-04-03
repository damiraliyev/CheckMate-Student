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
    
    
    //For teachers
//    func findUser(with email: String, completion: @escaping (String, String) -> Void) {
//        let ref = database.collection("teachers").whereField("email", isEqualTo: email)
//
//
//        ref.getDocuments { snapshot, error in
//            guard let snapshot = snapshot, error == nil else {
//                print("SNAPSHOT WASN'T FOUND")
//                return
//            }
//
//            let name = snapshot.documents.first?.get("name") as? String ?? ""
//            let surname = snapshot.documents.first?.get("surname") as? String ?? ""
//
//            completion(name, surname)
//        }
//
//    }
    
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
            let docID = DatabaseManager.shared.database.collection("students").document("Damir Aliyev")
            var totalAttendanceCount = 0
            docID.getDocument {snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    return
                }
                
                let studentID = snapshot.get("id") as? String ?? ""
                
                let ref = DatabaseManager.shared.database.collection("subjects")
                    .whereField("code", isGreaterThan: "\(code)")
                    .whereField("code", isLessThan: "\(code)u{f8ff}]")
                    .whereField("enrolledStudents", arrayContains: studentID)
                print("SUBJECTS THAT ENTERS TO QUERYAMOUNTOFCLASSES", code)
                ref.getDocuments { snapshot, error in
                    guard let snapshot = snapshot, error == nil else {
                        print("queryAmountOfClasses: \(error)")
                        return
                    }
                    print("QUERY AMOUNT OF CLASSES", snapshot.documents.count)
                    for doc in snapshot.documents {
                        print("NEW WAY TO CALCULATE ATTENDANCE!!!", (doc.get("dates") as? [String])?.count ?? 15 )
                        totalAttendanceCount += (doc.get("dates") as? [String])?.count ?? 15
                    }
                    completion(totalAttendanceCount)
                    totalAttendanceCount = 0
                }
                
            }
            
            
        }
    
    func querySubjects(name: String, surname: String, completion: @escaping ([Subject]) -> Void) {
        var subjects: [Subject] = []
//        totalAttendanceCount  = 0
//        absenceCount = 0
        let docID = DatabaseManager.shared.database.collection("students").document("\(name) \(surname)")
        print("QUERYSUBJECT", docID)
        let dispatchGroup = DispatchGroup()
        print("QUERY SUBJECTS CHECK FOR THE BUG")
        
        docID.getDocument { [weak self] snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                return
            }
        
            guard let studentID = snapshot.get("id") else { return }
            
            
            DatabaseManager.shared.database.collection("subjects")
                .whereField("enrolledStudents", arrayContains: studentID)
                .order(by: "id")
                .getDocuments  { (querySnapshot, error) in
                    print("LISTENER WILL BE TRIGGERED")
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            let code = document.get("code") as? String ?? ""
                            let name = document.get("name") as? String ?? ""
                            print("CODEEEEE", String(code.prefix(6)))
                            
                            
                            dispatchGroup.enter()
                            self?.queryAmountOfClasses(subjectCode: String(code.prefix(6))) { total in
                                self?.queryAttendance(
                                    name: UserDefaults.standard.value(forKey: "name") as? String ?? "",
                                    surname: UserDefaults.standard.value(forKey: "surname") as? String ?? "",
                                    for: String(code.prefix(6)),
                                    completion: { absence in
                                        guard let contains = self?.checkIfContains(subjects: subjects,name: name) else { return }
                                    
                                    if !contains {
//                                        print("NEED TO APPEND", self?.totalAttendanceCount)
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
//                                    self?.totalAttendanceCount = 0
//                                    self?.absenceCount = 0;
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

        print("QUERY ATTENDANCE CHECK FOR THE BUG")
        
        var absenceCount = 0

        docID
            .getDocument { [weak self] snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                return
            }

            guard let studentID = snapshot.get("id") else {
                return
            }

            print("FIELD PATH DOCUMENT ID", FieldPath.documentID())
            DatabaseManager.shared.database.collection("attendance")
                .whereField("code", isGreaterThanOrEqualTo: subject)
                .whereField("code", isLessThan: "\(subject)u{f8ff}]")
                .getDocuments { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    print("Error")
                    return
                }

                print("SNAPSHOT DOCUMENTS COUNT:", snapshot.documents.count)

                for document in snapshot.documents {
                    let dates = document.data().keys //dates 15.03.2023...
                    print("DATES ATTENDANCEC LENGTH", dates)
                    for key in dates {
                        let value = document.data()[key] // returns array

                        if let arr = value as? [Any]{
                            if let dict = arr[0] as? [String: Any] {
                                guard let attendances = dict["\(studentID)"] as? [Int] else { continue }

                                print("Attendances", attendances)
//                                self?.totalAttendanceCount += attendances.count
                                print("ATTENDANCEC LENGTH", attendances.count)
                                for attendance in attendances {
                                    if(attendance == 0) {
                                        absenceCount += 1;
                                    }
                                }
                                

                            } else {
                                print("ZAPARILSYA")
                            }
                        } else {
                            print("NOOOOOASOFSDOASODSODOSDOSADO")
                        }
                        
                    }
                    
                    
                }
                    print("Why 0?", absenceCount)
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
            .getDocuments {[weak self] snapshot, error in
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
    
    
    
}

