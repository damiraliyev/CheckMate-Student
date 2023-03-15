//
//  CollectionViewViewModelType.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 10.03.2023.
//

import Foundation

protocol CollectionViewViewModelType: AnyObject {
    func querySubjects(name: String, surname: String, completion: @escaping () -> Void)
    func numberOfRows() -> Int
    func cellViewModel(for indexPath: IndexPath) -> CollectionViewCellViewModelType?
}
