//
//  PostView.swift
//  InstaDC
//
//  Created by IC Deis on 6/12/23.
//

import SwiftUI

struct PostView: View {
   @EnvironmentObject private var postsVM: PostsVM
   @State var post: Post
   let showDetails: Bool
   let addAnimation: Bool
   
   init(post: Post, showDetails: Bool = true, addAnimation: Bool = false) {
      _post = State(wrappedValue: post)
      self.showDetails = showDetails
      self.addAnimation = addAnimation
   }
   
   @State private var animateLike: Bool = false
   @State private var showDialog: Bool = false
   @State private var dialogOption: DialogOptions = .options
   
   @State private var image: UIImage?

   @AppStorage(UDKeys.uid) private var currentUserID: String?
   
   var body: some View {
      VStack(alignment: .leading, spacing: 0) {
         Divider()
         
         // MARK: - Header Section
         if showDetails {
            headerSection
         }
         
         // MARK: - Post Image
         mainPostImage
         
         // MARK: - Action Buttons
         if showDetails {
            footerSection            
         }
      }
      
      .confirmationDialog(dialogOption.title, isPresented: $showDialog, titleVisibility: .visible) {
         dialogOptionButtons } message: {
            if let message = dialogOption.message {
               Text(message)
            }
         }
   }
}


extension PostView {
   
   private var headerSection: some View {
      HStack(spacing: 6) {
         NavigationLink {
            LazyView {
               ProfileView(userID: post.userID, isMyProfile: false)
            }
         } label: {
            ProfilePhoto(userID: post.userID)
               .frame(width: 30, height: 30)
            Text(post.username)
               .font(.callout)
               .fontWeight(.medium)
               .foregroundColor(.primary)
               .lineLimit(1)
         }
         Spacer()
         
         Button {
            if currentUserID != nil {
               showDialog = true
            } else {
               postsVM.showOnboardingView.toggle()
            }
         } label: {
            Image(systemName: "ellipsis")
               .font(.title3)
               .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0))
               .foregroundColor(.primary)
         }
      }
      .padding(8)
   }
   
   private var mainPostImage: some View {
      ZStack {
         if let uiimage = image {
            Image(uiImage: uiimage)
               .resizable()
               .scaledToFit()
               .frame(maxWidth: .infinity)
         } else {
            Rectangle()
               .fill(Material.ultraThinMaterial)
               .frame(maxWidth: .infinity, minHeight: 220, maxHeight: 220)
         }
//         if addAnimation {
//            LikeAnimationView(animate: $animateLike)
//         }

      }
//      .animation(.easeOut(duration: 1), value: image)
      .onTapGesture(count: 2) {
         Task {
            self.post = try await postsVM.likePost(post: post)
         }
         AnalyticsManager.shared.likeDoubleTap(username: post.username)
      }
      .onAppear {
         StorageManager.shared.getPostImage(withUrl: post.imageURL) { image in
            self.image = image
         }
      }
   }
   
   private var footerSection: some View {
      VStack(alignment: .leading, spacing: 10) {
         HStack(spacing: 20) {
            ZStack {
               if post.likes.contains(currentUserID ?? "") {
                  Image(systemName: "heart.fill")
                     .foregroundColor(.red)
               } else {
                  Image(systemName: "heart")
               }
            }
            .onTapGesture {
               Task {
                  self.post = try await postsVM.likePost(post: post)
               }
               AnalyticsManager.shared.likeHeartPressed(username: post.username)
            }
            
            if currentUserID != nil {
               NavigationLink {
                  CommentsView(postID: post.postID)
               } label: {
                  Image(systemName: "bubble.left")
                     .foregroundColor(.primary)
               }
            } else {
               Image(systemName: "bubble.left")
                  .foregroundColor(.primary)
                  .onTapGesture {
                     postsVM.showOnboardingView.toggle()
                  }
            }
            
            Button {
               sharePost()
            } label: {
               Image(systemName: "paperplane")
                  .foregroundColor(.primary)
            }
            
            Spacer()
         }
         .font(.title3)
         
         if let caption = post.caption {
            Text(caption)            
         }
      }
      .padding(10)
   }
   
   @ViewBuilder private var dialogOptionButtons: some View {
      if dialogOption == .options {
         Group {
            Button {
               
            } label: {
               Text(ActionLocale.edit)
            }
            
            Button {
               print("DEBUG: Share button was pressed.")
            } label: {
               Text(ActionLocale.share)
            }
            
            Button {
               
            } label: {
               Text(ActionLocale.learn_more)
            }
            
            Button(role: .destructive) {
               dialogOption = .report
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                  showDialog.toggle()
               }
            } label: {
               Text(ActionLocale.report)
            }
            
            if currentUserID == post.userID {
               Button(role: .destructive) {
                  dialogOption = .delete
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                     showDialog.toggle()
                  }
                  print("DEBUG: Delete button was pressed.")
               } label: {
                  Text(ActionLocale.delete)
               }
            }
         }
      } else if dialogOption == .delete {
         Button(role: .destructive) {
            postsVM.deletePost(postID: post.postID)
         } label: {
            Text("Delete")
         }
         Button(role: .cancel) {
            dialogOption = .options
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//               showDialog.toggle()
//            }
         } label: {
            Text(ReportLocale.cancel)
         }
         
      } else {
         Button(role: .destructive) {
            postsVM.reportPost(reason: "Spam post", postID: post.postID)
         } label: {
            Text(ReportLocale.spam)
         }
         
         Button(role: .destructive) {
            postsVM.reportPost(reason: "Copyrighted post", postID: post.postID)
         } label: {
            Text(ReportLocale.copyright)
         }
         Button(role: .destructive) {
            postsVM.reportPost(reason: "Inappropriate post", postID: post.postID)
         } label: {
            Text(ReportLocale.inappropriate)
         }
         
         Button(role: .cancel) {
            dialogOption = .options
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//               showDialog.toggle()
//            }
         } label: {
            Text(ReportLocale.cancel)
         }
      }
   }
}

extension PostView {
   
   enum DialogOptions {
      case options
      case report
      case delete
      
      var title: LocalizedStringKey {
         switch self {
         case .options: return ReportLocale.what_would_you_like_to_do
         case .report: return ReportLocale.reporting_post_to_the_team
         case .delete: return DeletePostLocale.delete_post
         }
      }
      
      var message: LocalizedStringKey? {
         switch self {
         case .options: return nil
         case .report: return ReportLocale.why_are_you_reporting_this_post
         case .delete: return DeletePostLocale.are_you_sure_want_to_delete
         }
      }
   }
   
   private func sharePost() {
      let message: String = "Check out this post in website"
      let image = UIImage(named: "cars-4")!
      let url = URL(string: "https://www.apple.com")!

      let activityView = UIActivityViewController(activityItems: [message, image, url], applicationActivities: nil)
      let viewController = getRootViewController()
      viewController?.present(activityView, animated: true)
   }
   
}


//struct PostView_Previews: PreviewProvider {
//   static var previews: some View {
//      NavigationStack {
//         PostView(post: dev.post1, showDetails: true, addAnimation: true)
//      }
//   }
//}
