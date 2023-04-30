//
//  RegisterViewModel.swift
//  TwitterClone
//
//  Created by Toan Phan Nguyen Song on 30/04/2023.
//

import Foundation
import FirebaseAuth
import Combine

final class RegisterViewModel: ObservableObject{
    @Published var email: String?
    @Published var password: String?
    @Published var isRegistrationFormValid: Bool = false
    @Published var user: User?
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
        AuthManager.shared.registerUser(email: email!, password: password!).sink{_ in
            
        } receiveValue: { user in
            self.user = user
        }.store(in: &subscriptions)
    }
}
