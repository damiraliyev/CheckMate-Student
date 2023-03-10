//
//  AccountInfoViewModelType.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 10.03.2023.
//

import Foundation
protocol AccountInfoViewModelType: AnyObject {
    var fullName: String { get }
    var email: String { get }
}
