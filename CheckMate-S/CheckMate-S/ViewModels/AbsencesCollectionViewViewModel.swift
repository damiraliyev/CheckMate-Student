//
//  AbsencesCollectionViewViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 06.05.2023.
//


import UIKit
class AbsencesCollectionViewViewModel {
    private var absenceClasses: [AbsenceClass] = [
    ]

    func numberOfRows() -> Int {
        return absenceClasses.count
    }
    
    func absenceClassCellViewModel(for indexPath: IndexPath) -> AbsenceCollectionViewCellViewModel {
        let absenceClass = absenceClasses[indexPath.row]
        
        return AbsenceCollectionViewCellViewModel(absenceClass: absenceClass)
    }
    
    func getAbsenceClasses(shortSubjectCode: String, completion: @escaping () -> Void) {
        DatabaseManager.shared.getAbsenceClassesForSubject(shortSubjectCode: shortSubjectCode) {[weak self] dates, times in
        
//            var i = 0
            print("dates in getAbsenceClasses", dates)
            print("times in getAbsenceClasses", times)
            
            for i in 0..<dates.count {
                let absentClass = AbsenceClass(date: dates[i], time: times[i])
                self?.absenceClasses.append(absentClass)
            }

            self?.absenceClasses.sort(by: {
                $0.date < $1.date
            })
            completion()
        }
    }
}
