//
//  PostsVM.swift
//  InstaDC
//
//  Created by IC Deis on 6/13/23.
//

import Foundation
import FirebaseAuth

@MainActor
final class PostsVM: ObservableObject {
   @Published var posts: [Post] = []
   @Published var myPosts: [Post] = []
   @Published var myLikesCount: Int = 0
   @Published var isLoading: Bool = false
   
   @Published var postID: String = ""
   @Published var user: DBUser? = nil
   
   @Published var showAlert: Bool = false
   @Published var alertTitle: String = ""
   @Published var alertMessage: String = ""
   
   @Published var showOnboardingView: Bool = false
   
   private let postManager = PostManager.shared
   
   init() {
      getListenedPosts(shuffle: false)
   }
   
   init(shuffle: Bool) {
      getListenedPosts(shuffle: shuffle)
   }

   
   func getListenedPosts(shuffle: Bool) {
      postManager.addListenerForPosts { data in
         if shuffle {
            self.posts = data.shuffled()
         } else {
            self.posts = data
         }
      }
   }
   
   func getPosts() {
      Task {
         posts = try await postManager.getAllPosts()
      }
   }
   
   func deletePost(postID: String) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
         Task {
            try await self.postManager.deletePost(postID: postID)
         }
      }
   }
   
   func getUser() {
      guard let user = getFromUserDefaults(as: DBUser.self, key: UDKeys.dbuser) else { return }
      self.user = user
      print("DEBUG: PostVM - \(user.uid)")
   }
   
   func likePost(post: Post) async throws -> Post {
      guard let uid = UserDefaults.standard.string(forKey: UDKeys.uid) else {
         showOnboardingView.toggle()
         return Post(post: post)
      }
      if post.likes.contains(uid) {
         try await PostManager.shared.unlikePost(postID: post.postID, userID: uid)
      } else {
         try await PostManager.shared.likePost(postID: post.postID, userID: uid)
      }
      return try await postManager.getPost(postID: post.postID)
   }
   
   func reportPost(reason: String, postID: String) {
      guard let _ = UserDefaults.standard.string(forKey: UDKeys.uid) else {
         showOnboardingView.toggle()
         return
      }
      Task {
         let result = try await postManager.reportPost(reason: reason, postID: postID)
         if result {
            alertTitle = "Reported!"
            alertMessage = "Thank you for reporting! \nYour report has been submitted successfully to the Report Adminstrator."
         } else {
            alertTitle = "Error!"
            alertMessage = "Could not submit your report to the Report Adminstrator."
         }
         showAlert.toggle()
      }
   }
   
}
