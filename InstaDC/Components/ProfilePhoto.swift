//
//  ProfilePhoto.swift
//  InstaDC
//
//  Created by IC Deis on 6/25/23.
//

import SwiftUI

struct ProfilePhoto: View {
   @State private var image: UIImage?
   let userID: String
   
    var body: some View {
       ZStack {
          if let uiimage = image {
             Image(uiImage: uiimage)
                .resizable()
                .scaledToFill()
          } else {
             Circle()
                .fill(.ultraThinMaterial)
          }
       }
       .clipShape(Circle())
       .task {
          StorageManager.shared.getProfilePhoto(withUid: userID) { image in
             self.image = image
          }
       }
    }
}

struct ProfilePhoto_Previews: PreviewProvider {
    static var previews: some View {
       ProfilePhoto(userID: "eoI5bY6o7vRFdhtwiXW1qr10YFW2")
    }
}
