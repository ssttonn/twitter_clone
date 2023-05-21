//
//  DatabaseManager.swift
//  TwitterClone
//
//  Created by Toan Phan Nguyen Song on 08/05/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import Combine

class DatabaseManager{
    static let shared = DatabaseManager()
    let db = Firestore.firestore()
    let usersCollectionName: String = "users"
    
    func collectionUsers(add user: User) -> AnyPublisher<Bool, Error>{
        let twitterUser = TwitterUser(from: user)
        return db.collection(usersCollectionName).document(twitterUser.id).setData(from: twitterUser).map{_ in
            return true
        }.eraseToAnyPublisher()
    }
    
    func retrieveUser(with id: String) -> AnyPublisher<TwitterUser, Error>{
        return db.collection(usersCollectionName).document(id).getDocument().tryMap{ try $0.data(as: TwitterUser.self) }.eraseToAnyPublisher()
    }
    
    func updateUserProfile(uid: String, with updatedFields: [String: Any]) -> AnyPublisher<Bool, Error>{
        return db.collection(usersCollectionName).document(uid).updateData(updatedFields).map{ _ in
            true
        }.eraseToAnyPublisher()
    }
}
