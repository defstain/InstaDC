//
//  CommentsView.swift
//  InstaDC
//
//  Created by IC Deis on 6/13/23.
//

import SwiftUI

struct CommentsView: View {
   @StateObject private var vm: CommentsVM
   let postID: String
   
   init(postID: String) {
      self.postID = postID
      _vm = StateObject(wrappedValue: CommentsVM(postID: postID))
   }
   
   var body: some View {
      VStack(alignment: .leading) {
         
         ScrollView {
            LazyVStack(spacing: 5) {
               ForEach(vm.comments) { comment in
                  CommentView(comment: comment)
               }
            }
            .padding(.top, 8)
         }
         
         HStack(spacing: 5) {
            ProfilePhoto(userID: vm.user?.uid ?? "")
               .frame(width: 40, height: 40)
               .clipShape(Circle())
            
            HStack {
               TextField(CommonLocale.placeholder, text: $vm.content)
                  .autocorrectionDisabled()
                  .submitLabel(.done)
               
               Button {
                  vm.uploadComment()
               } label: {
                  Text(CommonLocale.send)
                     .font(.headline)
                     .foregroundColor(.blue)
               }
               .opacity(vm.isLoading ? 0.1 : 1.0)
               .disabled(vm.isLoading)
            }
            .padding(10)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
         }
         .padding(10)
      }
      .navigationTitle(CommentLocale.comments)
      .navigationBarTitleDisplayMode(.inline)
      .alert(vm.alertTitle, isPresented: $vm.showAlert, actions: { }) {
         Text(vm.alertMessage)
      }
      .toolbar(.hidden, for: .tabBar)
   }
}


struct CommentsView_Previews: PreviewProvider {
   static var previews: some View {
      NavigationStack {
         CommentsView(postID: "I9zGOcz3Zo8IOo1iNiyy")
      }
   }
}
