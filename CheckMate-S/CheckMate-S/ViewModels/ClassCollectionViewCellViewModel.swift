//
//  SubjectCollectionViewCellViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 22.03.2023.
//

import Foundation

final class ClassCollectionViewCellViewModel: ClassCollectionViewCellViewModelType {
    
    let subjectClass: SubjectClass
    
    var subjectCode: String {
        return subjectClass.subjectCode
    }
    
    var subjectName: String {
        return subjectClass.subjectName
    }
    
    var startTime: String {
        return subjectClass.startTime
    }
    
    var endTime: String {
        return subjectClass.endTime
    }
    
    init(subjectClass: SubjectClass) {
        self.subjectClass = subjectClass
    }
    
    
}
