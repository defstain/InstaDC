//
//  ContentView.swift
//  InstaDC
//
//  Created by IC Deis on 7/15/23.
//

import SwiftUI

struct ContentView: View {
   @Environment(\.colorScheme) private var colorSchema
   @Environment(\.scenePhase) private var scenePhase
   
   @StateObject private var authVM = AuthenticationVM()
   @StateObject private var postsVM = PostsVM()
   @StateObject private var chatsVM = ChatsVM()
   
   @State private var isLocked: Bool = true
   @State private var isTimerRunOut: Bool = false
   @State private var counter: Int = 0
   
   @State private var showMessagingView: Bool = false
   
   @AppStorage("app_locale") private var appLocale: String = "en"
   @AppStorage(UDKeys.uid) var uid: String?
   @AppStorage(PassKeys.showLockScreen) private var showLockScreen: Bool = false
   @AppStorage(PassKeys.passTimeRequirement) private var remainingTime: Int = 0
   
   let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
   
   
   var body: some View {
      ZStack {
         TabView {
            feedSection
            exploreSection
            uploadSection
            notificationSection
            profileSection
         }
         .environment(\.locale, .init(identifier: appLocale))
         
         ZStack {
            if isLocked && showLockScreen {
               LockScreen(isLocked: $isLocked)
                  .transition(.move(edge: .top))
            }
         }
      }
      .fullScreenCover(isPresented: $postsVM.showOnboardingView) {
         OnboardingView()
            .environmentObject(authVM)
      }
      .onChange(of: scenePhase) { newPhase in
         if newPhase == .background && isTimerRunOut {
            isLocked = true
         }
      }
      .onChange(of: isLocked) { newValue in
         if newValue == false  {
            counter = 0
         }
      }
      .onReceive(timer) { value in
         if counter <= remainingTime {
            counter += 1
            isTimerRunOut = false
         } else {
            isTimerRunOut = true
         }
      }
      .toolbarBackground(.visible, for: .tabBar)
   }
}


extension ContentView {
   
   private var feedSection: some View {
      NavigationStack {
         if postsVM.posts.isEmpty {
            ShimmerEffect()
         } else {
            FeedView(posts: postsVM.posts, title: MainLocale.feed)
               .alert(postsVM.alertTitle, isPresented: $postsVM.showAlert, actions: { }, message: { Text(postsVM.alertMessage) })
               .toolbar {
                  ToolbarItem(placement: .navigationBarTrailing) {
                     Button {
                        showMessagingView.toggle()
                     } label: {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                           .scaleEffect(0.9)
                           .foregroundColor(.primary)
                     }
                  }
               }
               .fullScreenCover(isPresented: $showMessagingView) {
                  MessagesView()
                     .environmentObject(chatsVM)
               }
         }
      }
      .environmentObject(postsVM)
      .environmentObject(chatsVM)
      .tabItem {
         Image(systemName: "tornado")
         Text(MainLocale.feed)
      }
   }
   
   private var exploreSection: some View {
      NavigationStack {
         ExploreView()
      }
      .environmentObject(postsVM)
      .environmentObject(chatsVM)
      .tabItem {
         Image(systemName: "photo.stack")
         Text(MainLocale.explore)
      }
   }
   
   private var uploadSection: some View {
      UploadView()
         .environmentObject(postsVM)
         .tabItem {
            Image(systemName: "plus.viewfinder")
            Text(MainLocale.upload)
         }
   }
   
   private var notificationSection: some View {
      NavigationStack {
         NotificationView()
      }
      .tabItem {
         Image(systemName: "bell")
         Text(MainLocale.notification)
      }
   }
   
   private var profileSection: some View {
      ZStack {
         if let userID = uid {
            NavigationStack {
               ProfileView(userID: userID, isMyProfile: true)
            }
            .environmentObject(authVM)
            .environmentObject(postsVM)
            .environmentObject(chatsVM)
         } else {
            SignUpView()
               .environmentObject(authVM)
         }
      }
      .tabItem {
         Image(systemName: "sparkles")
         Text(MainLocale.profile)
      }
   }
   
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      ContentView()
   }
}
