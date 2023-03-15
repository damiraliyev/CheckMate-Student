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
        var code = subject.subjectCode.prefix(6)
        code.insert(" ", at: code.index(code.startIndex, offsetBy: 3))
        return String(code)
    }
    
    var subjectName: String {
        return subject.subjectName
    }
    
    init(subject: Subject) {
        self.subject = subject
    }
    
    
}
