//
//  UploadVM.swift
//  InstaDC
//
//  Created by IC Deis on 6/26/23.
//

import SwiftUI

@MainActor
final class UploadVM: ObservableObject {
   @Published var selectedImage: UIImage = UIImage(named: "cars-4")!
   @Published var isImageSelected: Bool = false
   @Published var showPostImageView: Bool = false
   @Published var isLoading: Bool = false
   @Published var showAlert: Bool = false
   
   @Published var alertTitle: String = ""
   @Published var alertMessage: String = ""
   
   
   init() { }
   
   func publishPost(caption: String) {
      guard let uid = UserDefaults.standard.string(forKey: UDKeys.uid),
            let displayName = UserDefaults.standard.string(forKey: UDKeys.displayName) else { return }
      isLoading = true
      Task {
         do {
            let result = try await StorageManager.shared
               .uploadImage(image: selectedImage, filename: UUID().uuidString, bucket: .post)
            
            try PostManager.shared.uploadPost(uid: uid, username: displayName, caption: caption, imageUrl: result.url)
            alertTitle = "Successfully uploaded!"
            showAlert.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
               self.showPostImageView = false
            }
            isLoading = false
         } catch {
            isLoading = false
            alertTitle = "Error!"
            alertMessage = "Could not upload your post. \nTry again bit later."
            showAlert.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
               self.showPostImageView = false
            }
         }
      }
   }
   
}
