//
//  AuthManager.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 09.03.2023.
//

import FirebaseAuth
import Foundation

final class AuthManager {
    
    static let shared = AuthManager()
    
    private init() {}
    let auth = Auth.auth()
    
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    public func signIn(
        email: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        auth.signIn(withEmail: email, password: password) { result, error in
            guard let result = result, error == nil else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(result.user))
            
            UserDefaults.standard.setValue(result.user.email, forKey: "email")
        }
    }
    
    public func signOut(completion: @escaping (Bool) -> Void) {
        
    }
    
}

