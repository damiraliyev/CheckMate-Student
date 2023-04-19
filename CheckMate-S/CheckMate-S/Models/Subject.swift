//
//  Subject.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 10.03.2023.
//

import Foundation

struct Subject {
    let subjectCode: String
    let subjectName: String
    let totalAttendanceCount: Int
    let absenceCount: Int
    
    static func makeSkeleton() -> Subject {
        return Subject(subjectCode: "--------", subjectName: "----", totalAttendanceCount: 15, absenceCount: 1)
    }
}
