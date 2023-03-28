//
//  ClassCollectionViewViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 22.03.2023.
//

import Foundation

final class ClassCollectionViewViewModel: ClassCollectionViewViewModelType {
    
    private var classes = [SubjectClass]()
    
//    func queryClassForDate(
//        subjectCode: String,
//        date: String,
//        completion: @escaping () -> Void
//    ) {
//        let studentEnrolledSubjects = DatabaseManager.shared.database.collection("enrollments")
//            .whereField("code", isGreaterThanOrEqualTo: subjectCode)
//            .whereField("code", isLessThan: subjectCode + "\u{f8ff}]")
//            .whereField("enrolledStudents", arrayContains: "200107116")
//
//
//        studentEnrolledSubjects.getDocuments { snapshot, error in
//            guard let snapshot = snapshot, error == nil else {
//                return
//            }
//
//
//        }
//
//    }
    
    
    func queryClassForDate(
           subjectCode: String,
           date: String,
           completion: @escaping () -> Void
       ) {
           print("APPROPRIATE SUBJECT", subjectCode)
           print(date)
           classes = []
          
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
                   
                   if snapshot.documents.count > 0 {
                       for document in snapshot.documents {
                           print("COUNNTTT", snapshot.documents.count)
                           if (document["enrolledStudents"] as! [String]).contains("200107116") {
                               code  = String((document["code"] as? String)?.suffix(6) ?? "")
                               name = String((document["name"] as? String) ?? "")
                               startTime = (document["startTime"] as? String ?? "")
                               endTime = (document["endTime"] as? String ?? "")
                               
                               let subjectClass = SubjectClass(subjectCode: code, subjectName: name, startTime: startTime, endTime: endTime)
                                   self?.classes.append(subjectClass)
                           }
                           
                       }
                  
                   }
                   
                   completion()
               
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
