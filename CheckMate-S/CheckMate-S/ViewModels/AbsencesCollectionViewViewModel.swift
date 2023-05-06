//
//  AbsencesCollectionViewViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 06.05.2023.
//


import UIKit
class AbsencesCollectionViewViewModel {
    private var absenceClasses: [AbsenceClass] = [
        AbsenceClass(date: "06.05.2023", time: "15:00"),
        AbsenceClass(date: "13.05.2023", time: "16:00")
    ]
    
    func numberOfRows() -> Int {
        return absenceClasses.count
    }
    
    func absenceClassCellViewModel(for indexPath: IndexPath) -> AbsenceCollectionViewCellViewModel {
        let absenceClass = absenceClasses[indexPath.row]
        
        return AbsenceCollectionViewCellViewModel(absenceClass: absenceClass)
    }
}
