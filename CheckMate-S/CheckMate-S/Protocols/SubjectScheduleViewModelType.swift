//
//  SubjectScheduleViewModelType.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 22.03.2023.
//

import Foundation

protocol SubjectScheduleViewModelType {
    var classCollectionViewViewModel: ClassCollectionViewViewModelType? { get set }
    var subjectCodeWithoutDetail: String { get }
    var dateText: String { get }
    func convertDate(day: Int?, month: Int?, year: Int?) -> String
}
