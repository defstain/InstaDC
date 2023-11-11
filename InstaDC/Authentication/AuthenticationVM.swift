//
//  AuthenticationVM.swift
//  InstaDC
//
//  Created by IC Deis on 6/22/23.
//

import SwiftUI
import Combine
import FirebaseAuth

@MainActor
final class AuthenticationVM: ObservableObject {
   @Published var userSession: FirebaseAuth.User? = nil
//   @Published var user: DBUser? = nil
   @Published var isSignedUp: Bool = false
   @Published var showOnboardingView2: Bool = false
   
   @Published var showAlertOnboarding: Bool = false
   @Published var showAlertOnboarding2: Bool = false
   
   @Published var usernameInput: String = ""
   @Published var nameInput: String = ""
   @Published var selectedImage: UIImage = UIImage(named: "cars-4")!
   
   @Published var checkUsernameInfo: LocalizedStringKey = AuthLocale.check_username_exist
   @Published var isUsernameExist: Bool = false
   
   private var appleHelper = SignInWithApple.shared
   private var googleHelper = GoogleSignInHelper.shared
   private var userManager = UserManager.shared
   private var storageManager = StorageManager.shared
//   private var hapticsManager = HapticManager.shared
   
   private var count = 0
   
   init() {
      getUserCurrent()
   }

   
   func signInWithGoogle() async throws {
      do {
         let credential = try await googleHelper.signIn()
         let result = try await userManager.signInUser(credential: credential)
         self.userSession = result
         usernameInput = ""
         do {
            let user = try await userManager.getUser(withUId: result.uid)
            getUserCurrent()
         } catch {
            print("DEBUG: User not found in Database.")
            showOnboardingView2.toggle()
            nameInput = result.displayName ?? ""
            return
         }
      } catch {
         print("DEBUG: Error Signing with Google method.")
      }
   }
   
   func getUserCurrent() {
      count += 1
      guard let user = Auth.auth().currentUser else { return }
      Task {
         let dbUser = try await userManager.getUser(withUId: user.uid)
         self.userSession = user

         UserDefaults.standard.set(dbUser.uid, forKey: UDKeys.uid)
         UserDefaults.standard.set(dbUser.displayName, forKey: UDKeys.displayName)
//         hapticsManager.genHaptic(type: .success)
         
         guard let imageUrl = dbUser.photoUrl else { return }
         let image = try await storageManager.getImage(withUrl: imageUrl)
         
         saveImageToUserDefaults(image: image, key: UDKeys.photo)
         saveToUserDefaults(data: dbUser, key: UDKeys.dbuser)
      }
   }

   func checkUsernameExistence() {
      guard usernameInput.count >= 5 else {
         checkUsernameInfo = AuthLocale.username_must_be
         return
      }
      checkUsernameInfo = CommonLocale.loading
      Task {
         try? await Task.sleep(for: .seconds(0.5))
         let result = try await userManager.checkUsername(username: usernameInput)
         if result {
            isUsernameExist = true
            checkUsernameInfo = AuthLocale.available
         } else {
           isUsernameExist = false
            checkUsernameInfo = AuthLocale.username_was_already_taken
         }
      }
   }
   
   func signOut() {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
         do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: UDKeys.uid)
            UserDefaults.standard.removeObject(forKey: UDKeys.username)
            UserDefaults.standard.removeObject(forKey: UDKeys.displayName)
            UserDefaults.standard.removeObject(forKey: UDKeys.bio)
            UserDefaults.standard.removeObject(forKey: UDKeys.photo)
            UserDefaults.standard.removeObject(forKey: UDKeys.dbuser)
            self.userSession = nil
         } catch  {
            print("DEBUG: Could not signed out.")
         }
      }
   }
   
}

// MARK: -- Make New User
extension AuthenticationVM {
   func makeNewUser() {
      guard let user = userSession else { return }
      Task {
         do {
            let result = try await storageManager.uploadImage(image: selectedImage, filename: "profile_photo", bucket: .profile)
            let success = try await userManager.makeNewUser(uid: user.uid, username: usernameInput, fullname: nameInput,
                                                            email: user.email ?? "no email", provider: "google")
            if success {
               isSignedUp = true
               DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                  self.getUserCurrent()
               }
            }
            try await userManager.updateProfilePhotoUrl(uid: user.uid, path: result.path, url: result.url)
         } catch {
            showAlertOnboarding2.toggle()
         }
      }
   }
}
