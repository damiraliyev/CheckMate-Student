//
//  ClassCollectionViewViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 22.03.2023.
//

import Foundation

final class ClassCollectionViewViewModel: ClassCollectionViewViewModelType {
    
    private var classes = [SubjectClass]()
    

    func queryClassForDate(
        studentID: String,
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
                                   
                                   let firstClassEnd = String(startHour) + ":50"
                                   let secondClassStart = String(startHour + 1) + ":00"
                                   
                                   let subjectFirstClass = SubjectClass(
                                    subjectCode: code,
                                    subjectName: name,
                                    startTime: startTime,
                                    endTime: firstClassEnd
                                   )
                                   
                                   let subjectSecondClass = SubjectClass(
                                    subjectCode: code,
                                    subjectName: name,
                                    startTime: secondClassStart,
                                    endTime: endTime)
                                   
                                   self?.classes.append(subjectFirstClass)
                                   self?.classes.append(subjectSecondClass)
                               } else {
                                   let subjectClass = SubjectClass(subjectCode: code, subjectName: name, startTime: startTime, endTime: endTime)
                                       self?.classes.append(subjectClass)
                               }
                               
                               
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
        NotificationCenter.post(<#T##self: NotificationCenter##NotificationCenter#>)
    }
    
    
}
