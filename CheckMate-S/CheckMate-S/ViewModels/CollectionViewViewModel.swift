//
//  CollectionViewViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 10.03.2023.
//

import Foundation

class CollectionViewViewModel: CollectionViewViewModelType {
    
    var subjects = [
        Subject(subjectCode: "CSS 342", subjectName: "Software Engineering"),
        Subject(subjectCode: "CSS 309", subjectName: "Low level architecture"),
        Subject(subjectCode: "INF 423", subjectName: "Statistics and data vizualization for data analysis")
    
    ]
    
    func numberOfRows() -> Int {
        return subjects.count
    }
    
    func cellViewModel(for indexPath: IndexPath) -> CollectionViewCellViewModelType? {
        let subject = subjects[indexPath.row]
        
        return CollectionViewCellViewModel(subject: subject)
    }
    
    
}
