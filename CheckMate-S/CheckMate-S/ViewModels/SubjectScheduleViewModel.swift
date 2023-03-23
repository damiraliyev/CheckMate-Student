//
//  SubjectScheduleViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 22.03.2023.
//

import Foundation

class SubjectScheduleViewModel: SubjectScheduleViewModelType {
    var classCollectionViewViewModel: ClassCollectionViewViewModelType? = nil
    
    var dateText: String {
        return String.date(from: Date()) ?? ""
    }
    
    private var subject: Subject
    
    var subjectCodeWithoutDetail: String {
        let codePart = String(subject.subjectCode.prefix(6))
        return codePart
    }
    
    init(subject: Subject) {
        self.subject = subject
    }
    
    
}
