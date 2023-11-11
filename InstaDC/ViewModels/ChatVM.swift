//
//  ChatVM.swift
//  InstaDC
//
//  Created by IC Deis on 7/24/23.
//

import Foundation

@MainActor
final class ChatVM: ObservableObject {
   @Published var bubbles: [Bubble] = []
   @Published var messageInput: String = ""
   
   private let userManager = UserManager.shared
   private let chatManager = ChatManager.shared
//   private let hapticManager = HapticManager.shared
   
   @Published var chatID: String? {
      didSet { getBubbles() }
   }
   
   init(chatID: String?) {
      self.chatID = chatID
//      getBubbles()
   }
   
   init() { }
   
   func getBubbles() {
      guard let chatID else { return }
      guard let _ = UserDefaults.standard.string(forKey: UDKeys.uid) else { return }
      chatManager.addListenerForBubbles(chatID: chatID) { bubbles, changed in
         if changed {
            NotificationManager.shared.askPermission()
            NotificationManager.shared.scheduleNotification(title: "New message", subtitle: "You have new message", count: 2 )
         }
         self.bubbles = bubbles
               
      }
   }
   
   
   
   func sendNewMessage(chatID: String) {
      guard !messageInput.isEmpty else { return }
      guard let uid = UserDefaults.standard.string(forKey: UDKeys.uid) else { return }
      Task {
         let bubble = Bubble(uid: uid, message: messageInput, dateSent: Date())
         try await chatManager.sendMessage(chatID: chatID, bubble: bubble)
         messageInput = ""
      }
   }
   
   func startMessaging(uid2: String, displayName2: String) {
      guard !messageInput.isEmpty,
            let displayName = UserDefaults.standard.string(forKey: UDKeys.displayName),
            let uid = UserDefaults.standard.string(forKey: UDKeys.uid) else { return }
      
      Task {
         let bubble = Bubble(uid: uid, message: messageInput, dateSent: Date())
         let chatID = try await chatManager.openNewChat(bubble: bubble)

         try await userManager.addNewChat(chatID: chatID, uid: uid, displayName: displayName, uid2: uid2, displayName2: displayName2, lastMessage: bubble.message, dateSent: bubble.dateSent)
         self.chatID = chatID
         getBubbles()
         messageInput = ""
      }
   }
   
}
