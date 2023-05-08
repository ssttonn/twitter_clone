//
//  LoginViewModel.swift
//  TwitterClone
//
//  Created by Toan Phan Nguyen Song on 02/05/2023.
//

import Foundation

class LoginViewModel: ObservableObject{
    @Published var email: String?
    @Published var password: String?
    @Published var isLoginFormValidated: Bool = false
    
}
