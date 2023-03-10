//
//  CollectionViewCellViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 10.03.2023.
//

import Foundation

class CollectionViewCellViewModel: CollectionViewCellViewModelType {
    
    private let subject: Subject
    
    var subjectCode: String {
        return subject.subjectCode
    }
    
    var subjectName: String {
        return subject.subjectName
    }
    
    init(subject: Subject) {
        self.subject = subject
    }
}
