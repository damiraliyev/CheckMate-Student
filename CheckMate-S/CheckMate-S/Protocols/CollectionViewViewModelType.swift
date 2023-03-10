//
//  CollectionViewViewModelType.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 10.03.2023.
//

import Foundation

protocol CollectionViewViewModelType: AnyObject {
    func numberOfRows() -> Int
    func cellViewModel(for indexPath: IndexPath) -> CollectionViewCellViewModelType?
}
