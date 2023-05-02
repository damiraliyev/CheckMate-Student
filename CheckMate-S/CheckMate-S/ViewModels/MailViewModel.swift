//
//  MailViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 29.04.2023.
//

import Foundation

final class MailViewModel {
    let selectedClass: SubjectClass
    let date: String
//    vc.fullSubjectCodeLabel.text = selectedClass.fullSubjectCode
//    vc.date = self?.selectedDate ?? "1.1.1970"
//    vc.teacherID = selectedClass.teacherID
//    vc.classTime = selectedClass.startTime
//
//    let components = selectedClass.teacherID.components(separatedBy: ".")
//    let teacherName = components[0].capitalized
//    let teacherSurname = components[1].capitalized
//
//    vc.teacherLabel.text = teacherName + " " + teacherSurname
    init(selectedClass: SubjectClass, date: String) {
        self.selectedClass = selectedClass
        self.date = date
    }
    
    var fullSubjectCode: String {
        return selectedClass.fullSubjectCode
    }
    
//    var absenceDate: String {
//        return da
//    }
    
    var teacherID: String {
        return selectedClass.teacherID
    }
    
    var classTime: String {
        return selectedClass.startTime
    }
    
    var teacherFullName: String {
        let components = selectedClass.teacherID.components(separatedBy: ".")
        let teacherName = components[0].capitalized
        let teacherSurname = components[1].capitalized
        
        return teacherName + " " + teacherSurname
    }
}
