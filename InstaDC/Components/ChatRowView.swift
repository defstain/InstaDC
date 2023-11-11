//
//  ChatRowView.swift
//  InstaDC
//
//  Created by IC Deis on 7/24/23.
//

import SwiftUI

struct ChatRowView: View {
   @StateObject private var chatVM: ChatVM
   let userID: String
   let displayName: String
   let chatID: String
   
   init(userID: String, displayName: String, chatID: String) {
      self.userID = userID
      self.displayName = displayName
      self.chatID = chatID
      _chatVM = StateObject(wrappedValue: ChatVM(chatID: chatID))
   }
   
   var body: some View {
      HStack(alignment: .top) {
         ProfilePhoto(userID: userID)
            .frame(width: 60, height: 60)
         VStack(alignment: .leading, spacing: 2) {
            Text(displayName)
               .font(.body)
               .fontWeight(.medium)
               .foregroundColor(.primary)
            Text(chatVM.bubbles.last?.message ?? "")
               .font(.subheadline)
               .foregroundColor(.gray)
               .lineLimit(2)
               .multilineTextAlignment(.leading)
               .lineSpacing(-5)
         }
         Spacer()
         Text(chatVM.bubbles.last?.dateSent ?? Date(), style: .time)
            .font(.subheadline)
            .foregroundColor(.gray)
      }
      .onAppear {
         Task {
            let _ = try await UserManager.shared.getUser(withUId: userID)
         }
      }
   }
}

struct ChatRowView_Previews: PreviewProvider {
   static var previews: some View {
      ChatRowView(userID: "8ktlbY41DuYrHBHWB9S6WgTMrhb2", displayName: "IC Deis", chatID: "sfcjdv")
   }
}
