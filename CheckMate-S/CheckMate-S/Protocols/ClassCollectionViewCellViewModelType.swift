//
//  SubjectCollectionViewCellViewModelType.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 22.03.2023.
//

import Foundation

protocol ClassCollectionViewCellViewModelType: AnyObject {
    var fullSubjectCode: String { get }
    var shortSubjectCode: String { get }
    var subjectName: String { get }
    var startTime: String { get }
    var endTime: String { get }
    var needToAttend: Int { get }
    var attended: Int { get }
    
}
