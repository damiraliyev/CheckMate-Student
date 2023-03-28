//
//  ClassCollectionViewViewModelType.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 22.03.2023.
//

import Foundation


protocol ClassCollectionViewViewModelType: AnyObject {
    
    func numberOfRows() -> Int
    func classCellViewModel(for indexPath: IndexPath) -> ClassCollectionViewCellViewModelType?
    func queryClassForDate(studentID: String, subjectCode: String, date: String, completion: @escaping () -> Void)
}
