//
//  MessagesView.swift
//  InstaDC
//
//  Created by IC Deis on 7/13/23.
//

import SwiftUI

struct MessagesView: View {
   @Environment(\.dismiss) private var dismiss
   @StateObject private var chatsVM = ChatsVM()
   
   @State private var showNewMessageView: Bool = false
   
   @AppStorage(UDKeys.uid) private var currentUserID: String = ""
   
   
   var body: some View {
      NavigationStack {
         List {
            chattedUsers
               .listRowSeparator(.hidden)
         }
         .listStyle(.plain)
         .refreshable { chatsVM.getAllChats() }
         .navigationTitle(MessagesLocale.messages)
         .navigationBarTitleDisplayMode(.inline)
         .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) { trailingToolbarItem }
         }
         .overlay {
            Text(chatsVM.infoMessage)
         }
      }
   }
}


extension MessagesView {
   
   private var chattedUsers: some View {
      ForEach(chatsVM.userChats, id: \.chatID) { chat in
         ChatRowView(userID: chat.uid, displayName: chat.displayName, chatID: chat.chatID)
            .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .background {
               NavigationLink {
                  ChatView(chatID: chat.chatID, userID: chat.uid, displayName: chat.displayName)
                     .environmentObject(chatsVM)
               } label: {  }
            }
      }
   }
   
}


// MARK: -- Toolbar Items
extension MessagesView {
   
   private var trailingToolbarItem: some View {
      Button {
         dismiss()
      } label: {
         Text(CommonLocale.done)
      }
   }
   
}


struct MessagesView_Previews: PreviewProvider {
   static var previews: some View {
      MessagesView()
   }
}
