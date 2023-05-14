//
//  HomeViewViewModel.swift
//  TwitterClone
//
//  Created by Toan Phan Nguyen Song on 08/05/2023.
//

import Foundation
import Combine
import FirebaseAuth

final class HomeViewViewModel: ObservableObject{
    @Published var user: TwitterUser?
    @Published var errorString: String?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func retrieveUser(){
        DatabaseManager.shared.retrieveUser(with: Auth.auth().currentUser?.uid ?? "").sink{ [weak self] completion in
            if case .failure(let error) = completion {
                self?.errorString = error.localizedDescription
            }
        } receiveValue: { [weak self] twitterUser in
            self?.user = twitterUser
        }.store(in: &subscriptions)
    }
}
