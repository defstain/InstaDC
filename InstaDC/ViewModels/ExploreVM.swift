//
//  ExploreVM.swift
//  InstaDC
//
//  Created by IC Deis on 7/11/23.
//

import SwiftUI

@MainActor
final class ExploreVM: ObservableObject {
   @Published private(set) var users = [DBUser]()
   @Published var searchInput: String = ""
   
   private let userManager = UserManager.shared
   
   init() {
      getAllUsers()
   }
   
   private func getAllUsers() {
      Task {
         self.users = try await userManager.getUsers()
      }
   }
   
   func getFilteredUsers() -> [DBUser] {
      if searchInput.isEmpty {
         return users
      } else {
         return users.filter { $0.displayName.localizedCaseInsensitiveContains(searchInput) }
      }
   }
   
}
