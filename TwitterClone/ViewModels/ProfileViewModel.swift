//
//  ProfileViewModel.swift
//  TwitterClone
//
//  Created by sstonn on 21/05/2023.
//

import Foundation
import Combine
import FirebaseAuth

class ProfileViewModel: ObservableObject{
    @Published var user: TwitterUser? = nil
    @Published var error: String? = nil
    
    private var subscriptions: [AnyCancellable] = []
    
    func retrieveUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        DatabaseManager.shared.retrieveUser(with: uid).sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.error = error.localizedDescription
            }
        } receiveValue: { [weak self] user in
            self?.user = user
        }.store(in: &subscriptions)
    }
}
