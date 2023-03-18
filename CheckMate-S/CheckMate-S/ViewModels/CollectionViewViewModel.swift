//
//  CollectionViewViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 10.03.2023.
//

import Foundation
import UIKit
import FirebaseFirestore

class CollectionViewViewModel: CollectionViewViewModelType {
    
    
    var subjects: [Subject] = []
    
    var totalAttendanceCount: Int = 0;
    var absenceCount: Int = 0;
    
//    func querySubjects(name: String, surname: String, completion: @escaping () -> Void) {
//        let docID = DatabaseManager.shared.database.collection("teachers").document("\(name) \(surname)")
//
//        docID.getDocument { [weak self] snapshot, error in
//            guard let snapshot = snapshot, error == nil else {
//                return
//            }
//
//            guard let teacherID = snapshot.get("id") else { return }
//
//            let subjectRef = DatabaseManager.shared.database.collection("subjects")
//
//            let querySubject = subjectRef.whereField("teacherID", isEqualTo: teacherID)
//
//            querySubject.getDocuments { [self] snapshot, error in
//                guard let snapshot = snapshot, error == nil else {
//                    return
//                }
//
//                for document in snapshot.documents {
//                    let code = document.get("code") as? String ?? ""
//                    let name = document.get("name") as? String ?? ""
//
//                    guard let contains = self?.checkIfContains(name: name) else { return }
//                    if !contains {
//                        self?.subjects.append(Subject(subjectCode: code, subjectName: name))
//                    }
//
//
//
//                    print("APPENDED:", self?.subjects.count)
//
//                }
//                completion()
//            }
//        }
    
    
    func querySubjects(name: String, surname: String, completion: @escaping () -> Void) {
        let docID = DatabaseManager.shared.database.collection("students").document("\(name) \(surname)")
        let dispatchGroup = DispatchGroup()
        
        docID.getDocument { [weak self] snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                return
            }
        
            guard let studentID = snapshot.get("id") else { return }
            
            
            DatabaseManager.shared.database.collection("subjects")
                .whereField("enrolledStudents", arrayContains: studentID)
                .getDocuments() { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            let code = document.get("code") as? String ?? ""
                            let name = document.get("name") as? String ?? ""
                            print("CODEEEEE", String(code.prefix(6)))
                            
                            dispatchGroup.enter()
                            self?.queryAttendance(name: "Damir", surname: "Aliyev", for: String(code.prefix(6)), completion: {
                                guard let contains = self?.checkIfContains(name: name) else { return }
                                
                                if !contains {
                                    print("NEED TO APPEND")
                                    self?.subjects.append(
                                        Subject(
                                            subjectCode: code,
                                            subjectName: name,
                                            totalAttendanceCount: self?.totalAttendanceCount ?? 0,
                                            absenceCount: self?.absenceCount ?? 0))
                                }
                                self?.totalAttendanceCount = 0
                                self?.absenceCount = 0;
                                dispatchGroup.leave()
                            })
                           
                        }
                        dispatchGroup.notify(queue: .main) { // Call the completion block when all tasks have finished
                            completion()
                        }
                    }
                }
        }
        
    }
    
    func queryAttendance(name: String, surname: String, for subject: String, completion: @escaping () -> Void) {
        let docID = DatabaseManager.shared.database.collection("students").document("\(name) \(surname)")
        
        
        docID.getDocument { [weak self] snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                return
            }
            
            guard let studentID = snapshot.get("id") else {
                return
            }
            
            DatabaseManager.shared.database.collection("attendance")
                .whereField(FieldPath.documentID(), isGreaterThan: "\(subject)")
                .whereField(FieldPath.documentID(), isLessThan: "\(subject)z")
                .getDocuments { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    print("Error")
                    return
                }
                    
                print("SNAPSHOT DOCUMENTS COUNT:", snapshot.documents.count)
                
                for document in snapshot.documents {
                    let dates = document.data().keys //dates 15.03.2023...
                    
                    for key in dates {
                        let value = document.data()[key] // returns array
                        
                        if let arr = value as? [Any]{
                            if let dict = arr[0] as? [String: Any] {
                                guard let attendances = dict["\(studentID)"] as? [Int] else { continue }
                                
                                print("Attendances", attendances)
                                self?.totalAttendanceCount += attendances.count
                                for attendance in attendances {
                                    if(attendance == 0) {
                                        self?.absenceCount += 1;
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
                completion()
            }

        }
    }
    
    
//    func queryAttendance(name: String, surname: String, completion: @escaping () -> Void) {
//        print("QUERY ATTENDANCE WAS SUCCESSFULL")
//        let docID = DatabaseManager.shared.database.collection("students").document("\(name) \(surname)")
//
//        print("DOCID", docID)
//
//        docID.getDocument { [weak self] snapshot, error in
//            guard let snapshot = snapshot, error == nil else {
//
//                return
//            }
//
//
//            guard let studentID = snapshot.get("id") else {
////                print("ERRRRROOOOOORRRRRR")
//                return
//            }
//
//            print("QUery attendance", studentID)
//
//            DatabaseManager.shared.database.collection("attendance")
//                .whereField("studentID", arrayContains: studentID)
//                .getDocuments() { (querySnapshot, error) in
//                    if let error = error {
//                        print("Error getting documents: \(error)")
//                    } else {
//                        print("EEELLLLLSSSSEEEEEE")
//                        for document in querySnapshot!.documents {
//                            print("AAAAAAAAA", document.data())
//                        }
//                        completion()
//                    }
//                }
//        }
//    }
    
    func checkIfContains(name: String) -> Bool {
        var contains = false
        
        for i in 0..<subjects.count {
            if subjects[i].subjectName == name {
                contains = true
            }
        }
        
        return contains
    }
    
   
    
    func numberOfRows() -> Int {
        print(subjects.count)
        return subjects.count
    }
    
    func cellViewModel(for indexPath: IndexPath) -> CollectionViewCellViewModelType? {
        let subject = subjects[indexPath.row]
        
        return CollectionViewCellViewModel(subject: subject)
    }

    
    
}
