//
//  User.swift
//  TwitterClone
//
//  Created by Toan Phan Nguyen Song on 08/05/2023.
//

import Foundation
import Firebase

struct TwitterUser: Codable{
    let id: String
    var displayName: String = ""
    var username: String = ""
    var followerCount: Int = 0
    var followingCount: Int = 0
    var createdOn: Date = Date()
    var bio: String = ""
    var avatarPath: String = ""
    var isUserOnboarded: Bool = false
    
    init(from firebaseUser: User){
        self.id = firebaseUser.uid
    }
}
