//
//  ChatsVM.swift
//  InstaDC
//
//  Created by IC Deis on 7/24/23.
//

import SwiftUI

@MainActor
final class ChatsVM: ObservableObject {
   @Published var userChats: [DBUserChat] = []
   @Published var infoMessage: LocalizedStringKey = ""
   
   private let userManager = UserManager.shared
   
   init() {
      getAllChats()
   }
   
   func getAllChats() {
      guard userChats.isEmpty else { return }
      guard let uid = UserDefaults.standard.string(forKey: UDKeys.uid) else { return }
      Task {
         self.userChats = try await userManager.getChats(uid: uid)
         if userChats.isEmpty {
            infoMessage = MessagesLocale.no_messages
         } else {            
            infoMessage = ""
         }
      }
   }
   
   
   
}
