//
//  StorageManager.swift
//  TwitterClone
//
//  Created by Toan Phan Nguyen Song on 15/05/2023.
//

import Foundation
import Combine
import FirebaseStorageCombineSwift
import FirebaseStorage

enum StorageError: Error{
    case invalidImageID
}

final class StorageManager{
    static let shared = StorageManager()
    let storage = Storage.storage()
    
    func getDownloadURL(for id: String?) -> AnyPublisher<URL, Error>{
        guard let id = id else{
            return Fail(error: StorageError.invalidImageID).eraseToAnyPublisher()
        }
        return storage.reference(withPath: id).downloadURL().eraseToAnyPublisher()
    }
    
    func uploadProfilePhoto(with id: String, image: Data, metaData: StorageMetadata) -> AnyPublisher<StorageMetadata, Error>{
        return storage.reference().child("images/\(id).jpg").putData(image, metadata: metaData).eraseToAnyPublisher()
    }
    
   
}
