//
//  PreviewProvider.swift
//  InstaDC
//
//  Created by IC Deis on 6/12/23.
//

import SwiftUI
import Firebase

extension PreviewProvider {
   
   static var dev: DeveloperPreview {
      return DeveloperPreview.shared
   }
   
}


class DeveloperPreview {
   
   static let shared = DeveloperPreview()
   private init() { }
   
   let user = DBUser(uid: "54gfgdvg2f1h", username: "deviss", displayName: "DEVISS", email: "Rennarion@gmail.com", bio: "I'm SwiftUI Developer", photoPath: "path",
                     photoUrl: "https://i1.sndcdn.com/avatars-000618622512-elyfci-t500x500.jpg", provider: "apple", followers: [""], dateJoined: Timestamp())
   
   let post1 = Post(postID: "1801", userID: "1801", username: "IC Deis", caption: "Made by DEVISS, Muslim Developer",
                    dateAdded: Date(), likes: [], imageURL: "red-car")
   
   let posts = [Post(postID: "500", userID: "501", username: "DEVISS", caption: "Caption for the Post",
                     dateAdded: Date(), likes: [], imageURL: "dodge-2"),
                Post(postID: "502", userID: "503", username: "EDDESS", caption: "I'm going to build new iOS app a lot like Instagram",
                     dateAdded: Date(), likes: [], imageURL: "hennessey-silver"),
                Post(postID: "504", userID: "505", username: "IC Deis", caption: "Learning Swift is more challenging me",
                     dateAdded: Date(), likes: [], imageURL: "bentley-continental"),
                Post(postID: "506", userID: "507", username: "LaaFerta", caption: nil,
                     dateAdded: Date(), likes: [], imageURL: "cars-4")]
   
}
