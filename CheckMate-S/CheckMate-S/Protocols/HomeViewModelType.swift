//
//  HomeViewModelType.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 10.03.2023.
//

import Foundation

protocol HomeViewModelType: AnyObject {
    var collectionViewViewModel: CollectionViewViewModelType? {get}
    var accountInfoViewModel: AccountInfoViewModelType? {get}
}
