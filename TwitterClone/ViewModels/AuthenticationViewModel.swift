//
//  RegisterViewModel.swift
//  TwitterClone
//
//  Created by Toan Phan Nguyen Song on 30/04/2023.
//

import Foundation
import FirebaseAuth
import Combine

final class AuthenticationViewModel: ObservableObject{
    @Published var email: String?
    @Published var password: String?
    @Published var isRegistrationFormValid: Bool = false
    @Published var user: User?
    @Published var errorString: String?
    private var subscriptions: Set<AnyCancellable> = []
    
    func validateRegistrationForm(){
        guard let email = email, let password = password else {
            isRegistrationFormValid = false
            return}
        isRegistrationFormValid = isValidEmail(email: email) && password.count >= 8
    }
    
    private func isValidEmail(email: String)-> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func registerUser(){
        AuthManager.shared.registerUser(email: email!, password: password!)
            .handleEvents(receiveOutput: { [weak self] user in
            self?.user = user
        })
        .sink{ [weak self] completion in
            if case .failure(let error) = completion {
                self?.errorString = error.localizedDescription
            }
        } receiveValue: {[weak self] user in
            self?.createRecord(for: user)
        }.store(in: &subscriptions)
    }
    
    func login(){
        AuthManager.shared.login(email: email!, password: password!)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.user = user
            })
            .sink{ [weak self] completion in
            if case .failure(let error) = completion {
                self?.errorString = error.localizedDescription
            }
        } receiveValue: { [weak self] user in
            self?.createRecord(for: user)
        }.store(in: &subscriptions)
    }
    
    func createRecord(for user: User){
        DatabaseManager.shared.collectionUsers(add: user).sink{ [weak self] completion in
            if case .failure(let error) = completion{
                self?.errorString = error.localizedDescription
            }
        } receiveValue: { state in
            print("Adding user record to database: \(state)")
        }.store(in: &subscriptions)
    }
}
