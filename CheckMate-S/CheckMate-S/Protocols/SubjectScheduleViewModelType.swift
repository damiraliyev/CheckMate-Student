//
//  SubjectScheduleViewModelType.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 22.03.2023.
//

import Foundation

protocol SubjectScheduleViewModelType {
    var classCollectionViewViewModel: ClassCollectionViewViewModelType? { get set }
    
    var fullSubjectCode: String { get }
    var subjectCodeWithoutDetail: String { get }
    var dateText: String { get set }
    var totalHours: Int { get }
    var presenceCount: Int { get }
    var absenceCount: Int { get }
    func convertDate(day: Int?, month: Int?, year: Int?) -> String
    func getAbsenceClasses(shortSubjectCode: String, completion: @escaping ([String: [Int]], String) -> Void)
    
}
