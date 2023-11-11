//
//  UserManager.swift
//  InstaDC
//
//  Created by IC Deis on 6/22/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

/// User Manager class
/// This class manages all user related actions in the databse
final class UserManager {
   
   @Published var userMain: DBUser?
   
   static let shared = UserManager()
   private init() {
      guard let uid = UserDefaults.standard.string(forKey: UDKeys.uid) else { return }
      Task {
         self.userMain = try await getUser(withUId: uid)
      }
   }
   
   private let userCollection = Firestore.firestore().collection("users")
   private func userDocument(uid: String) -> DocumentReference { return userCollection.document(uid) }
   private func chatsCollection(uid: String) -> CollectionReference { userDocument(uid: uid).collection("chats") }
   private func chatDocument(uid: String, chatID: String) -> DocumentReference { chatsCollection(uid: uid).document(chatID) }

   /// Returns current authenticated user
   func getUserCurrent() throws -> User {
      guard let user = Auth.auth().currentUser else { throw URLError(.cannotFindHost) }
      return user
   }
   
   /// Searches the user from the databse with the giiven user id and returns found user
   func getUser(withUId uid: String) async throws -> DBUser {
      print("DEBUG: getUser Func")
      let user = try await userDocument(uid: uid).getDocument()
      print("DEBUG: User - \(user.documentID)")
      return try await userDocument(uid: uid).getDocument(as: DBUser.self)
   }
   
   /// Returns all users
   func getUsers() async throws -> [DBUser] {
      return try await userCollection
         .limit(to: 100)
         .getDocuments(as: DBUser.self)
   }
   
   /// Updates profile photo in the database with given user id
   func updateProfilePhotoUrl(uid: String, path: String, url: String) async throws {
      try await userDocument(uid: uid).setData([DBUserFields.photoPath: path, DBUserFields.photoUrl: url], merge: true)
   }
   
   /// Updates username in the database with given user id
   func updateUsername(uid: String, username: String) async throws {
      try await userDocument(uid: uid).updateData([DBUserFields.username: username])
   }
   
   /// Updates display name in database with given user id
   func updateDisplayName(uid: String, displayName: String) async throws {
      try await userDocument(uid: uid).updateData([DBUserFields.displayName: displayName])
      let posts = try await PostManager.shared.getMyPosts(uid: uid)
      for post in posts {
         try await PostManager.shared.updatePostUsername(postID: post.postID, username: displayName)
      }
   }
   
   /// Updates bio in the database with given user id
   func updateUserBio(uid: String, bio: String) async throws {
      try await userDocument(uid: uid).setData([DBUserFields.bio: bio], merge: true)
   }
   
   /// Will follow current user to that user
   func followToUser(uid: String, followedUID: String) async throws {
      try await userDocument(uid: followedUID).updateData([DBUserFields.followers: FieldValue.arrayUnion([uid])])
   }
 
   /// Will unfollow current user to that user
   func unFollowFromUser(uid: String, followedUID: String) async throws {
      try await userDocument(uid: followedUID).updateData([DBUserFields.followers: FieldValue.arrayRemove([uid])])
   }

   /// Returns all chats associated to current user
   func getChats(uid: String) async throws -> [DBUserChat] {
      try await chatsCollection(uid: uid).getDocuments(as: DBUserChat.self)
   }
   
   /// Begiss new chat with specified user
   func addNewChat(chatID: String, uid: String, displayName: String, uid2: String, displayName2: String, lastMessage: String, dateSent: Date) async throws {
      let chat = DBUserChat(id: UUID().uuidString, chatID: chatID, uid: uid2, displayName: displayName2)
      let chat2 = DBUserChat(id: UUID().uuidString, chatID: chatID, uid: uid, displayName: displayName)
      
      try chatsCollection(uid: uid).addDocument(from: chat)
      try chatsCollection(uid: uid2).addDocument(from: chat2)
   }
   
   /// Deletes the chat from the database by the given id
   func deleteChat(chatID: String, uid: String, uid2: String) async throws {
      try await chatsCollection(uid: uid).document(chatID).delete()
      try await chatsCollection(uid: uid2).document(chatID).delete()
   }
   
   
}


// MARK: -- Authentication Section
extension UserManager {
   
   /// Signs in the user to Firebase
   func signInUser(credential: AuthCredential) async throws -> User {
      let result = try await Auth.auth().signIn(with: credential)
      return result.user
   }
   
   /// Makes new user in the databse
   func makeNewUser(uid: String, username: String, fullname: String, email: String, provider: String) async throws -> Bool {
      let data: [String: Any] = [
         DBUserFields.uid: uid,
         DBUserFields.username: username.lowercased(),
         DBUserFields.displayName: fullname,
         DBUserFields.bio: "",
         DBUserFields.email: email,
         DBUserFields.photoUrl: "",
         DBUserFields.provider: provider,
         DBUserFields.followers: [String](),
         DBUserFields.dateJoined: Timestamp()
      ]
      try await userDocument(uid: uid).setData(data)
      return true
   }
   
   /// Checks the username if it exist
   func checkUsername(username: String) async throws -> Bool {
      let result = try await userCollection
         .whereField(DBUserFields.username, isEqualTo: username.lowercased())
         .getDocuments(as: DBUser.self)
      print("DEBUG: Result - \(result)")
      if result.isEmpty {
         return true
      } else {
         return false
      }
   }
   
   /// Signs out current user from device
   func signOut() throws {
      try Auth.auth().signOut()
   }
   
}
