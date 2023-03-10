//
//  CollectionViewCellViewModelType.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 10.03.2023.
//

import Foundation

protocol CollectionViewCellViewModelType: AnyObject {
    var subjectCode: String { get }
    var subjectName: String { get }
}
