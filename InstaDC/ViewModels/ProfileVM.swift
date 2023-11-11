//
//  ProfileVM.swift
//  InstaDC
//
//  Created by IC Deis on 6/24/23.
//

import SwiftUI
import FirebaseAuth

@MainActor
final class ProfileVM: ObservableObject {
   @Published var user: DBUser? = nil
   private var userID: String
   
   @Published var myPosts: [Post] = []
   @Published var myLikesCount: Int = 0
   
   @Published var selectedPhoto: UIImage = UIImage(named: "plant-logo")!
   @Published var username: String = ""
   @Published var displayName: String = ""
   @Published var bio: String = ""
   @Published var isLoading: Bool = false
   
   @Published var showPhotoChangeAlert: Bool = false
   @Published var alertTitle: String = ""
   @Published var alertMessage: String = ""
   @Published var success: Bool = false
   
   private let userManager = UserManager.shared
   private let postManager = PostManager.shared
   private var storageManager = StorageManager.shared
   
   init(userID: String, isMyProfile: Bool) {
      self.userID = userID
      getUserInfo()
      getMyPosts(userID: userID)
   }
   
   private func getProfilePhoto() {
      guard let url = user?.photoUrl else { return }
      Task {
         self.selectedPhoto = try await storageManager.getImage(withUrl: url)
      }
   }
   
   func getUserInfo() {
      Task {
         let user = try await userManager.getUser(withUId: userID)
         self.user = user
         self.username = user.username
         self.displayName = user.displayName
         self.bio = user.bio ?? ""
         getProfilePhoto()
      }
   }
   
   func getMyPosts(userID: String) {
      Task {
         let posts = try await postManager.getMyPosts(uid: userID)
         self.myLikesCount = posts.map { $0.likes.count }.reduce(0, +)
         self.myPosts = posts
      }
   }
   
   func updateProfilePhoto() {
      isLoading = true
      Task {
         do {
            let result = try await storageManager.uploadImage(image: selectedPhoto, filename: DBUserFields.profilePhoto, bucket: .profile)
            try await userManager.updateProfilePhotoUrl(uid: userID, path: result.path, url: result.url)
            updateUI()
            storageManager.updateCache(uid: userID, image: selectedPhoto)
         } catch {
            alertTitle = "Error!"
            alertMessage = "Could not change profile photo."
            showPhotoChangeAlert.toggle()
            isLoading = false
         }
      }
   }
   
   func updateUsername() {
      Task {
         do {
            try await userManager.updateUsername(uid: userID, username: username)
            updateUI()
         } catch {
            alertTitle = "Error!"
            alertMessage = "Failed to update username."
            showPhotoChangeAlert.toggle()
            isLoading = false
         }
      }
   }
   
   func updateDisplayName() {
      Task {
         do {
            try await userManager.updateDisplayName(uid: userID, displayName: displayName)
            updateUI()
         } catch {
            alertTitle = "Error!"
            alertMessage = "Could not update user display name."
            showPhotoChangeAlert.toggle()
            isLoading = false
         }
      }
   }
   
   func updateUserBio() {
      isLoading = true
      Task {
         do {
            try await userManager.updateUserBio(uid: userID, bio: bio)
            updateUI()
         } catch {
            alertTitle = "Error!"
            alertMessage = "Could not update bio."
            showPhotoChangeAlert.toggle()
            isLoading = false
         }
      }
   }
   
   func follow() {
      guard let currentUser = Auth.auth().currentUser,
            let followedUser = user else { return }
      Task {
         if followedUser.followers.contains(currentUser.uid) {
            try await userManager.unFollowFromUser(uid: currentUser.uid, followedUID: userID)
            getUserInfo()
         } else {
            try await userManager.followToUser(uid: currentUser.uid, followedUID: userID)
            getUserInfo()
         }
      }
   }
   
   private func updateUI() {
      alertTitle = "Successfully updated!"
      showPhotoChangeAlert.toggle()
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
         self.success.toggle()
         self.isLoading = false
      }
      getUserInfo()
   }
   
}
