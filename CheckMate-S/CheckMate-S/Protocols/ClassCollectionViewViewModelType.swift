//
//  ClassCollectionViewViewModelType.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 22.03.2023.
//

import Foundation


protocol ClassCollectionViewViewModelType: AnyObject {
    var classes: [SubjectClass] { get set}
    var tokens: [String]? { get }
    var enteredToken: String? { get set }
    func getTokensForClass(date: String,fullSubjectCode: String,completion: @escaping () -> Void)
    func checkToken(fullSubjectCode: String) -> Bool
    func updateAttendanceStatus(date: String, studentID: String, fullSubjectCode: String, completion: @escaping (Bool) -> Void)
    var selectedIndexPath: IndexPath? { get set }
    func selectedClass() -> SubjectClass?
    func numberOfRows() -> Int
    func classCellViewModel(for indexPath: IndexPath) -> ClassCollectionViewCellViewModelType?
    func queryClassForDate(studentID: String, fullSubjectCode: String, subjectCode: String, date: String, completion: @escaping () -> Void)
    func loadAttendanceStatusesForDate(date: String, fullSubjectCode: String, completion: @escaping ([Int]) -> ())
    
}
