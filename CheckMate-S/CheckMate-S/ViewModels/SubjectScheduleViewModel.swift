//
//  SubjectScheduleViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 22.03.2023.
//

import Foundation

final class SubjectScheduleViewModel: SubjectScheduleViewModelType {
    var classCollectionViewViewModel: ClassCollectionViewViewModelType? = nil
    
    var dateText = String.date(from: Date()) ?? ""

    
    private var subject: Subject
    
    var subjectCodeWithoutDetail: String {
        let codePart = String(subject.subjectCode.prefix(6))
        return codePart
    }
    
    var fullSubjectCode: String {
        return subject.subjectCode
    }
    
    
    var needToAttend = 0
    var attended = 0
    
    init(subject: Subject) {
        self.subject = subject
    }
    
    func convertDate(day: Int?, month: Int?, year: Int?) -> String {
        guard let day = day,
              let month = month,
              let year = year
        else {
            return ""
        }
        
        var dayString = String(day)
        if String(day).count == 1 {
            dayString = "0\(day)"
        }
        
        var monthString = String(month)
        if monthString.count == 1 {
            monthString = "0\(monthString)"
        }
        return "\(dayString).\(monthString).\(year)"
    }
    
//    func loadAttendanceStatusesForDate() {
//        print("IN load attendance statuses for date", dateText)
//        DatabaseManager.shared.loadAttendanceStatusForParticularDate(dataString: dateText) { [weak self] dict in
//            print("Fetched \(dict)")
//            if dict.count == 0 {
//                print("There is no information for this particular date.")
//            } else {
//                self?.needToAttend = dict["needToAttend"] ?? 0
//                self?.attended = dict["attended"] ?? 0
//            }
//        }
//    }
    
    
}
