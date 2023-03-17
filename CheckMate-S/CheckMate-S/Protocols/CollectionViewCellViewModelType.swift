//
//  CollectionViewCellViewModelType.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 10.03.2023.
//

import Foundation
import UIKit

protocol CollectionViewCellViewModelType: AnyObject {
    var subjectCode: String { get }
    var subjectName: String { get }
    var totalAttendanceCount: Int { get }
    var absenceCount: Int { get }
    var progress: Float {get}
    var percentage: String { get }
    var progressColor: UIColor { get }
    
    
}
