//
//  ProfileDataFormViewModel.swift
//  TwitterClone
//
//  Created by Toan Phan Nguyen Song on 15/05/2023.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import Combine

final class ProfileDataFormViewModel: ObservableObject{
    @Published var avatarPath: String?
    @Published var displayName: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarImage: UIImage?
    @Published var isFormValidated: Bool = false
    @Published var error: String?
    
    private var subscriptions: [AnyCancellable] = []
    
    func validateForm(){
        guard avatarImage != nil, displayName != nil, displayName!.count > 2, username != nil, username!.count > 2, bio != nil, bio!.count > 2 else {
            isFormValidated = false
            return
        }
        isFormValidated = true
    }
    
    func uploadAvatar(){
        guard let uuid = FirebaseAuth.Auth.auth().currentUser?.uid else {
            return
        }
        
        guard let imageData = avatarImage?.jpegData(compressionQuality: 0.5) else {return}
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        StorageManager.shared.uploadProfilePhoto(with: "profile_\(uuid)", image: imageData, metaData: metaData)
            .flatMap({ metaData in
                return StorageManager.shared.getDownloadURL(for: metaData.path)
            })
            .sink{ [weak self] completion in
            if case .failure(let error) = completion {
                self?.error = error.localizedDescription
            }
        } receiveValue: { [weak self] url in
            DispatchQueue.main.async {
                self?.avatarPath = url.absoluteString
                self?.validateForm()
            }
        }.store(in: &subscriptions)
    }
    
    func submit(){
        uploadAvatar()
    }
}
