//
//  HomeViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 10.03.2023.
//

import Foundation

final class HomeViewModel: HomeViewModelType {
    let student = Student(name: "Bakdaulet", surname: "Aidarbekov", email: "bakdaulet.aidarbekov@stu.sdu.edu.kz")
    
    var collectionViewViewModel: CollectionViewViewModelType?
    var accountInfoViewModel: AccountInfoViewModelType?
   
    
    
    
    init(collectionViewViewModel: CollectionViewViewModelType, accountInfoViewModel: AccountInfoViewModelType) {
        self.collectionViewViewModel = collectionViewViewModel
//        collectionViewViewModel.querySubjects(name: student.name, surname: student.surname)
        self.accountInfoViewModel = accountInfoViewModel
    }
    
    
}
