//
//  UserModel.swift
//  InstaDC
//
//  Created by IC Deis on 6/22/23.
//

import Foundation
import Firebase

struct DBUser: Codable {
   let uid: String
   let username: String
   let displayName: String
   let email: String
   let bio: String?
   let photoPath: String?
   let photoUrl: String?
   let provider: String?
   let followers: [String]
   let dateJoined: Timestamp?
   
   enum CodingKeys: String, CodingKey {
      case uid
      case username
      case displayName = "display_name"
      case email
      case bio
      case photoPath = "photo_path"
      case photoUrl = "photo_url"
      case provider
      case followers
      case dateJoined = "date_joined"
   }
}
