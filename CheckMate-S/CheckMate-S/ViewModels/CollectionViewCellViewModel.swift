//
//  CollectionViewCellViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 10.03.2023.
//

import Foundation
import UIKit

final class CollectionViewCellViewModel: CollectionViewCellViewModelType {
    
    private let subject: Subject
//    private let attendance: Int
    
    var subjectCode: String {
        print("SUBJECT CODE FIX:", subject.subjectCode)
        var code = subject.subjectCode.prefix(6)
        
        if code.count == 6 {
            code.insert(" ", at: code.index(code.startIndex, offsetBy: 3))
        }
        
        return String(code)
    }
    
    var subjectName: String {
        return subject.subjectName
    }
    
    var totalAttendanceCount: Int {
        return subject.totalAttendanceCount
    }
    
    var absenceCount: Int {
        return subject.absenceCount
    }
    
    var progress: Float {
        print("IN VIEW MODEL", Float(absenceCount) / Float(totalAttendanceCount))
        return Float(absenceCount) / Float(totalAttendanceCount)

    }
    
    var percentage: String {
        
        return "\(Int(round(progress * 100)))%"
    }
    
    var progressColor: UIColor {
        print("LOADED COLLECTION VIEW progressColor", percentage)
        if (Int(percentage.prefix(percentage.count - 1)) ?? 0 < 10) {
            return .lightGreen
        } else if(Int(percentage.prefix(percentage.count - 1)) ?? 0 < 20) {
            return .lightYellow
        } else if(Int(percentage.prefix(percentage.count - 1)) ?? 0 < 30) {
            return .orange
        } else {
            return .systemRed
        }
    }
    
    init(subject: Subject) {
        self.subject = subject
    }
    
    
}
