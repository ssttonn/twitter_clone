//
//  AuthManager.swift
//  TwitterClone
//
//  Created by Toan Phan Nguyen Song on 30/04/2023.
//

import Foundation
import FirebaseAuth
import FirebaseAuthCombineSwift
import Combine

class AuthManager{
    static let shared = AuthManager()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func registerUser(email: String, password: String) -> AnyPublisher<User, Error>{
        return Auth.auth().createUser(withEmail: email, password: password).map(\.user).eraseToAnyPublisher()
    }
}
