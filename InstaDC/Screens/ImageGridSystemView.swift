//
//  ImageGridSystemView.swift
//  InstaDC
//
//  Created by IC Deis on 6/13/23.
//

import SwiftUI

struct ImageGridSystemView: View {
   let posts: [Post]
   let columns: [GridItem] = [
      GridItem(.flexible(), spacing: 2),
      GridItem(.flexible(), spacing: 2),
      GridItem(.flexible(), spacing: 2)]
   
    var body: some View {
       LazyVGrid(columns: columns, spacing: 2) {
          ForEach(posts) { post in
             NavigationLink {
                FeedView(posts: [post], title: MainLocale.post)
             } label: {
                SingleGridImage(imageUrl: post.imageURL)
             }
          }
       }
    }
}

struct ImageGridSystemView_Previews: PreviewProvider {
    static var previews: some View {
       ImageGridSystemView(posts: dev.posts)
    }
}
