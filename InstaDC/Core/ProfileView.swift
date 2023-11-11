//
//  ProfileView.swift
//  InstaDC
//
//  Created by IC Deis on 6/17/23.
//

import SwiftUI

struct ProfileView: View {
   @EnvironmentObject private var authVM: AuthenticationVM
   @EnvironmentObject private var chatsVM: ChatsVM
   
   @StateObject private var vm: ProfileVM
//   @StateObject private var postsVM: PostsVM
   @State private var showSettingsView: Bool = false
   
   @AppStorage(UDKeys.uid) private var currentUserID: String = "no uid"
   
   
   var userID: String
   var isMyProfile: Bool
      
   init(userID: String, isMyProfile: Bool = false) {
      self.userID = userID
      self.isMyProfile = isMyProfile
      _vm = StateObject(wrappedValue: ProfileVM(userID: userID, isMyProfile: isMyProfile))
//      _postsVM = StateObject(wrappedValue: PostsVM(userID: userID))
   }
   
   var body: some View {
      ScrollView(showsIndicators: false) {
         VStack(alignment: .leading) {
           
            profilePhotoAndInfo
            followButton
            Divider()
            someUserStats
            
          Divider()
         }
         .padding(.horizontal, 10)
         
         ImageGridSystemView(posts: vm.myPosts)
      }
      .navigationTitle(MainLocale.profile)
      .navigationBarTitleDisplayMode(.inline)
      .task {
         if vm.myPosts.isEmpty {
            vm.getMyPosts(userID: userID)
         }
      }
      .refreshable {
         vm.getUserInfo()
         vm.getMyPosts(userID: userID)
      }
      .toolbar {
         if isMyProfile {
            settingsIconItem
         }
      }
      .fullScreenCover(isPresented: $showSettingsView) {
         SettingsView()
            .environmentObject(authVM)
            .environmentObject(vm)
      }
   }
}


extension ProfileView {
   
   private var profilePhotoAndInfo: some View {
      HStack(alignment: .top, spacing: 20) {
         ProfilePhoto(userID: userID)
            .frame(width: 100, height: 100)
         VStack(alignment: .leading, spacing: 5) {
            if let user = vm.user {
               Text(vm.displayName)
                  .font(.title)
                  .bold()
               Text(user.username.asUsername())
                  .font(.headline)
               Text(user.bio ?? "")
                  .font(.callout)
                  .multilineTextAlignment(.leading)
                  .lineLimit(3)
            } else {
               RoundedRectangle(cornerRadius: 4)
                  .fill(.ultraThinMaterial)
                  .frame(width: 170, height: 25)
               RoundedRectangle(cornerRadius: 4)
                  .fill(.ultraThinMaterial)
                  .frame(width: 140, height: 23)
               RoundedRectangle(cornerRadius: 4)
                  .fill(.ultraThinMaterial)
                  .frame(width: 100, height: 20)
            }
         }
         Spacer()
      }
      .padding(.bottom, 5)
   }
   
   @ViewBuilder private var followButton: some View {
         if currentUserID != userID {
            HStack {
               NavigationLink {
                  ChatView(userID: userID, displayName: vm.displayName)
                     .environmentObject(chatsVM)
               } label: {
                  Text(ProfileLocale.message)
                     .font(.headline)
                     .frame(maxWidth: .infinity)
                     .minimumScaleFactor(0.6)
                     .padding(10)
                     .foregroundColor(.white)
                     .background(.blue.opacity(0.9))
                     .cornerRadius(10)
               }
            if vm.user != nil {
               Button {
                  vm.follow()
               } label: {
                  if let user = vm.user, user.followers.contains(currentUserID) {
                     Text(ProfileLocale.unfollow)
                        .font(.headline)
                        .frame(width: 80)
                        .padding(10)
                  } else {
                     Text(ProfileLocale.follow)
                        .cornerRadius(10)
                        .font(.headline)
                        .frame(width: 80)
                        .padding(10)
                        .foregroundColor(.white)
                        .background(.mint)
                        .cornerRadius(10)
                  }
               }
            } else {
               RoundedRectangle(cornerRadius: 10)
                  .fill(.ultraThinMaterial)
                  .frame(width: 80, height: 40)
                  .padding(.horizontal)
            }
         }
      }
   }
   
   private var someUserStats: some View {
      HStack {
         Spacer()
         VStack {
            Text(vm.myPosts.count.asString())
               .fontWeight(.bold)

            Text(ProfileLocale.posts)
               .font(.callout)
         }
         .frame(width: 100)
         
         VStack {
            Text(vm.myLikesCount.asString())
               .fontWeight(.bold)
            Text(ProfileLocale.likes)
               .font(.callout)
         }
         .frame(width: 100)
         
         VStack {
            Text(vm.user?.followers.count.asString() ?? "0")
               .fontWeight(.bold)
            Text(ProfileLocale.followings)
               .font(.callout)
         }
         .frame(width: 120)
         Spacer()
      }
      .font(.title3)
      .fontWeight(.medium)
   }
   
   private var settingsIconItem: ToolbarItem<(), some View> {
      ToolbarItem(placement: .navigationBarTrailing) {
         Button {
            showSettingsView.toggle()
         } label: {
            Image(systemName: "gear")
         }
      }
   }
   
}


struct ProfileView_Previews: PreviewProvider {
   static var previews: some View {
      NavigationStack {
         ProfileView(userID: "dkgdbbgd4gg5df", isMyProfile: true)
      }
      .environmentObject(AuthenticationVM())
      .environmentObject(ChatVM())
   }
}
