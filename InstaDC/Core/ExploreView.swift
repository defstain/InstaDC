//
//  ExploreView.swift
//  InstaDC
//
//  Created by IC Deis on 6/13/23.
//

import SwiftUI

struct ExploreView: View {
   @StateObject private var postsVM: PostsVM
   @StateObject private var vm = ExploreVM()
   @State private var showSearchView: Bool = false
   
   init() {
      _postsVM = StateObject(wrappedValue: PostsVM(shuffle: true))
   }
   
   var body: some View {
      ZStack {
         ScrollView(showsIndicators: false) {
            CarouselView(posts: postsVM.posts)
            ImageGridSystemView(posts: postsVM.posts)
         }
         ScrollView {
            searchField
            usersList
         }
         .padding(.horizontal)
         .padding(.top, 1)
         .frame(height: showSearchView ? nil : 0)
         .background(.regularMaterial)
         .animation(.spring(), value: showSearchView)
      }
      .navigationTitle(MainLocale.explore)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar { toolbarSearchIcon }
//      .toolbarBackground(.hidden, for: .tabBar)
   }
}


extension ExploreView {
   
   private var searchField: some View {
      TextField(CommonLocale.search, text: $vm.searchInput)
         .padding(10)
         .background(.gray.opacity(0.2))
         .cornerRadius(8)
         .padding(.bottom)
         .padding(.top, 5)
   }

   
   private var usersList: some View {
      ForEach(vm.getFilteredUsers(), id: \.uid) { user in
         NavigationLink {
            LazyView {
               ProfileView(userID: user.uid, isMyProfile: false)
            }
         } label: {
            HStack(alignment: .top) {
               ProfilePhoto(userID: user.uid)
                  .frame(width: 40, height: 40)
               VStack(alignment: .leading) {
                  Text(user.displayName)
                     .font(.headline)
                     .foregroundColor(.black)
                  Text("@\(user.username)")
                     .font(.subheadline)
                     .foregroundColor(.secondary)
               }
               Spacer()
            }
            .padding(.bottom, 5)
         }
      }
   }
      
   private var toolbarSearchIcon: ToolbarItem<(), some View> {
      ToolbarItem(placement: .navigationBarTrailing) {
         Button {
            showSearchView.toggle()
         } label: {
            if showSearchView {
               Text(CommonLocale.close)
            } else {
               Image(systemName: "magnifyingglass")
                  .foregroundColor(.black)
            }
         }
      }
   }
   
}

//struct ExploreView_Previews: PreviewProvider {
//   static var previews: some View {
//      NavigationStack {
//         ExploreView()
//      }
//   }
//}
