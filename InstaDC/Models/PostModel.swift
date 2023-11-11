//
//  PostModel.swift
//  InstaDC
//
//  Created by IC Deis on 6/12/23.
//

import Foundation

struct Post: Identifiable, Hashable, Codable {
   var id = UUID().uuidString
   let postID: String
   let userID: String
   let username: String
   let caption: String?
   let dateAdded: Date
   let likes: [String]
   let imageURL: String
   
   enum CodingKeys: String, CodingKey {
      case postID = "post_id"
      case userID = "user_id"
      case username
      case caption
      case dateAdded = "date_added"
      case likes = "likes"
      case imageURL = "image_url"
   }
   
   func hash(into hasher: inout Hasher) {
      hasher.combine(id)
   }
   
   init(postID: String, userID: String, username: String, caption: String?, dateAdded: Date, likes: [String], imageURL: String) {
      self.postID = postID
      self.userID = userID
      self.username = username
      self.caption = caption
      self.dateAdded = dateAdded
      self.likes = likes
      self.imageURL = imageURL
   }
   
   init(post: Post) {
      self.id = post.id
      self.postID = post.postID
      self.userID = post.userID
      self.username = post.username
      self.caption = post.caption
      self.dateAdded = post.dateAdded
      self.likes = post.likes
      self.imageURL = post.imageURL
   }
   
}

let carNames: [String] = ["bentley-continental", "bmw-e94", "red-ferrari", "bmw-series-4", "cars-4", "dodge-3", "hennessey-silver", "mercedes-amg", "red-car", "dodge-2"]
