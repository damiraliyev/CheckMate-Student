//
//  CollectionViewViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 10.03.2023.
//

import Foundation
import UIKit
import FirebaseFirestore

final class CollectionViewViewModel: CollectionViewViewModelType {
    
    var subjects: [Subject] = []
    
    private var selectedIndexPath: IndexPath?
    
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
    
//    func queryAmountOfClasses(subjectCode code: String) {
//        let ref = DatabaseManager.shared.database.collection("subject")
//            .whereField("code", isGreaterThan: "\(code)")
//            .whereField("code", isLessThan: "\(code)u{f8ff}]")
//
//        ref.getDocuments { snapshot, error in
//            guard let snapshot = snapshot, error == nil {
//                print("queryAmountOfClasses: error")
//                return
//            }
//
//        }
//    }
    
    func queryAmountOfClasses(subjectCode code: String, completion: @escaping (Int) -> ()) {
            let docID = DatabaseManager.shared.database.collection("students").document("Damir Aliyev")
            
            docID.getDocument { [weak self] snapshot, error in
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
                        self?.totalAttendanceCount += (doc.get("dates") as? [String])?.count ?? 15
                    }
                    completion(self?.totalAttendanceCount ?? 15)
                    self?.totalAttendanceCount = 0
                }
                
            }
            
            
        }
    
    func querySubjects(name: String, surname: String, completion: @escaping () -> Void) {
        subjects = []
        totalAttendanceCount  = 0
        absenceCount = 0
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
                                    guard let contains = self?.checkIfContains(name: name) else { return }
                                    
                                    if !contains {
                                        print("NEED TO APPEND", self?.totalAttendanceCount)
                                        self?.subjects.append(
                                            Subject(
                                                subjectCode: code,
                                                subjectName: name,
                                                totalAttendanceCount: total,
                                                absenceCount: absence)
                                        )
                                        self?.subjects.sort(by: { s1, s2 in
                                            s1.subjectCode < s2.subjectCode
                                        })
                                    }
                                    self?.totalAttendanceCount = 0
                                    self?.absenceCount = 0;
                                    dispatchGroup.leave()
                                })
                            }
                            
                           
                        }
                        dispatchGroup.notify(queue: .main) { // Call the completion block when all tasks have finished
                            completion()
                        }
                    }
                }
        }
        
    }
    
    func queryAttendance(name: String, surname: String, for subject: String, completion: @escaping (Int) -> Void) {
        let docID = DatabaseManager.shared.database.collection("students")
            .document("\(name) \(surname)")

        print("QUERY ATTENDANCE CHECK FOR THE BUG")

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
                    print("Why 0?", self?.absenceCount)
                    completion(self?.absenceCount ?? 0)
                    
                
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
    
    func viewModelForSelectedRow() -> SubjectScheduleViewModelType? {
        guard let selectedIndexPath = selectedIndexPath else {
            return nil
        }
        
        return SubjectScheduleViewModel(subject: subjects[selectedIndexPath.row])
    }
    
    
    func selectRow(atIndextPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func cellViewModel(for indexPath: IndexPath) -> CollectionViewCellViewModelType? {
        let subject = subjects[indexPath.row]
        
        return CollectionViewCellViewModel(subject: subject)
    }

    
    
}
