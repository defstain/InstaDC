//
//  SingleGridImage.swift
//  InstaDC
//
//  Created by IC Deis on 6/25/23.
//

import SwiftUI

struct SingleGridImage: View {
   @State private var image: UIImage?
   let imageUrl: String
   
   var body: some View {
      ZStack {
         if let uiimage = image {
            Image(uiImage: uiimage)
               .resizable()
               .scaledToFill()
               .frame(maxWidth: UIScreen.main.bounds.width / 3, minHeight: 65, maxHeight: 220)
               .clipShape(Rectangle())
         } else {
            Rectangle()
               .fill(Material.ultraThinMaterial)
               .frame(maxWidth: .infinity, minHeight: 65, maxHeight: 220)
         }
      }
      .onAppear {
         StorageManager.shared.getPostImage(withUrl: imageUrl) { image in
            self.image = image
         }
      }
   }
}

struct SingleGridImage_Previews: PreviewProvider {
   static var previews: some View {
      SingleGridImage(imageUrl: "fkvm")
   }
}
