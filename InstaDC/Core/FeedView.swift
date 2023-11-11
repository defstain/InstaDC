//
//  FeedView.swift
//  InstaDC
//
//  Created by IC Deis on 6/12/23.
//

import SwiftUI

struct FeedView: View {
   @State private var startMinY: CGFloat = 0
   @State private var offset: CGFloat = 0
   
   @State private var navbarSize: CGFloat = 97
   
   let posts: [Post]
   let title: LocalizedStringKey
  
   var body: some View {
      ScrollView(.vertical, showsIndicators: false) {
         LazyVStack {
            ForEach(posts) { post in
               PostView(post: post, addAnimation: true)
            }
         }
      }
      .navigationTitle(title)
      .navigationBarTitleDisplayMode(.inline)     
   }
}




//struct FeedView_Previews: PreviewProvider {
//   static var previews: some View {
//      NavigationStack {
//         FeedView(posts: [dev.post1], title: "Feed")
//      }
//   }
//}
