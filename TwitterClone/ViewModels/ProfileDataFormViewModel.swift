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
    @Published var isUserOnboarded: Bool = false
    
    private var subscriptions: [AnyCancellable] = []
    
    func validateForm(){
        guard avatarImage != nil, displayName != nil, displayName!.count > 2, username != nil, username!.count > 2, bio != nil, bio!.count > 2 else {
            isFormValidated = false
            return
        }
        isFormValidated = true
    }
    
    func uploadAvatar(onFinished: @escaping () -> Void){
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
            } else if case .finished = completion{
                onFinished()
            }
        } receiveValue: { [weak self] url in
            DispatchQueue.main.async {
                self?.avatarPath = url.absoluteString
                self?.validateForm()
            }
        }.store(in: &subscriptions)
    }
    
    func submit(){
        uploadAvatar{ [weak self] in
            self?.updateDataToFireStore()
        }
    }
    
    private func updateDataToFireStore(){
        guard let avatarPath = avatarPath, let bio = bio, let displayName = displayName, let username = username, let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        DatabaseManager.shared.updateUserProfile(uid: uid, with: [
            "avatarPath": avatarPath,
            "bio": bio,
            "username": username,
            "displayName": displayName,
            "isUserOnboarded": true
        ]).sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.error = error.localizedDescription
            }
        } receiveValue: {[weak self] onboarded in
            self?.isUserOnboarded = onboarded
        }
        .store(in: &subscriptions)
    }
}
