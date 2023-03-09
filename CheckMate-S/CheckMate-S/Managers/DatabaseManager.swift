//
//  DatabaseManager.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 09.03.2023.
//

import FirebaseFirestore
import Foundation

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init() {}
    
    let database = Firestore.firestore()
}
