//
//  ClassCollectionViewViewModelType.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 22.03.2023.
//

import Foundation


protocol ClassCollectionViewViewModelType: AnyObject {
    var classes: [SubjectClass] { get set}
    func numberOfRows() -> Int
    func classCellViewModel(for indexPath: IndexPath) -> ClassCollectionViewCellViewModelType?
    func queryClassForDate(studentID: String, fullSubjectCode: String, subjectCode: String, date: String, completion: @escaping () -> Void)
    func loadAttendanceStatusesForDate(date: String, fullSubjectCode: String, completion: @escaping ([Int]) -> ())
    
}
