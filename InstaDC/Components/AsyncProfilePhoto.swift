//
//  AsyncProfilePhoto.swift
//  InstaDC
//
//  Created by IC Deis on 6/25/23.
//

import SwiftUI

struct AsyncProfilePhoto: View {
   @State private var localeImage: UIImage? = nil
   @State private var imageUrl: String? = nil
   @AppStorage(UDKeys.uid) private var uid: String?
   
   let userID: String
   
   var body: some View {
      ZStack {
         if let image = localeImage {
            Image(uiImage: image)
               .resizable()
               .scaledToFill()
               .frame(width: 100, height: 100)
         } else if let urlString = imageUrl, let url = URL(string: urlString) {
            AsyncImage(url: url) { image in
               image
                  .resizable()
                  .scaledToFill()
            } placeholder: {
               Circle()
                  .fill(.ultraThinMaterial)
            }
         } else {
            Circle()
               .fill(.ultraThinMaterial)
         }
      }
      .clipShape(Circle())
      .onAppear {
         checkIfPhotoExist()
      }
   }
}


extension AsyncProfilePhoto {
   
   private func checkIfPhotoExist() {
      
      if uid != nil && userID == uid {
         self.localeImage = getImageFromUserDefaults(key: UDKeys.photo)         
      } else {
         Task {
            StorageManager.shared.getProfilePhoto(withUid: userID) { image in
               self.localeImage = image
            }
         }
      
      }
   }
   
}

struct AsyncProfilePhoto_Previews: PreviewProvider {
   static var previews: some View {
      AsyncProfilePhoto(userID: "eoI5bY6o7vRFdhtwiXW1qr10YFW2")
         .frame(width: 100, height: 100)
   }
}
