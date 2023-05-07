//
//  AbsenceCollectionViewCellViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 06.05.2023.
//

class AbsenceCollectionViewCellViewModel {
    let absenceClass: AbsenceClass
    
    var date: String {
        return absenceClass.date
    }
    
    var time: String {
        return absenceClass.time
    }
    
    init(absenceClass: AbsenceClass) {
        self.absenceClass = absenceClass
    }
    
    
}
