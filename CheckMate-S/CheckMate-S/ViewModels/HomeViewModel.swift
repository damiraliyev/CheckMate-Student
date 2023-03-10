//
//  HomeViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 10.03.2023.
//

import Foundation

class HomeViewModel: HomeViewModelType {
    
    var collectionViewViewModel: CollectionViewViewModelType?
    var accountInfoViewModel: AccountInfoViewModelType?
    
    let student = Student(name: "Damir", surname: "Aliyev", email: "200107116@stu.sdu.edu.kz")
    
    init(collectionViewViewModel: CollectionViewViewModelType, accountInfoViewModel: AccountInfoViewModelType) {
        self.collectionViewViewModel = collectionViewViewModel
        self.accountInfoViewModel = accountInfoViewModel
    }
}
