//
//  ChatView.swift
//  InstaDC
//
//  Created by IC Deis on 7/24/23.
//

import SwiftUI

struct ChatView: View {
   @EnvironmentObject private var chatsVM: ChatsVM
   @StateObject private var vm = ChatVM()
   
   @State var chatID: String?
   let userID: String
   let displayName: String
   
   @AppStorage(UDKeys.uid) private var currentUserID = ""
   
   
   var body: some View {
      VStack {
         ScrollView {
            topChatInfo
            ForEach(vm.bubbles, id: \.id) { bubble in
               if bubble.uid == currentUserID {
                  MyMessageRow(message: bubble.message)
               } else {
                  UserMessageRow(message: bubble.message)
               }
            }
            
         }
         .padding(.horizontal, 10)
         .frame(maxWidth: .infinity)
         
         HStack {
            TextField(CommonLocale.placeholder, text: $vm.messageInput)
               .autocorrectionDisabled()
               .submitLabel(.done)
            
            Button {
               if let id = vm.chatID {
                  vm.sendNewMessage(chatID: id)
               } else {
                  vm.startMessaging(uid2: userID, displayName2: displayName)
                  chatsVM.getAllChats()
               }
            } label: {
               Text(CommonLocale.send)
                  .font(.headline)
                  .foregroundColor(.blue)
            }

         }
         .padding(12)
         .background(.ultraThinMaterial)
         .cornerRadius(10)
         .padding(.horizontal)
         .onAppear {
            chatsVM.userChats.forEach { chat in
               if chat.uid == userID {
                  vm.chatID = chat.chatID
               }
            }
         }
         .padding(.bottom, 10)
      }
      .scrollDismissesKeyboard(.interactively)
      .toolbar(.hidden, for: .tabBar)
      .navigationTitle(displayName)
      .navigationBarTitleDisplayMode(.inline)
   }
}


extension ChatView {
   
   private var topChatInfo: some View {
      VStack {
         ProfilePhoto(userID: userID)
            .frame(width: 90, height: 90)
         Text(displayName)
            .font(.title3)
            .bold()
            .foregroundColor(.primary)
            .font(.footnote)
            .foregroundColor(.gray)
      }
      .padding(.bottom)
   }
   
}

struct ChatView_Previews: PreviewProvider {
   static var previews: some View {
      NavigationStack {
         ChatView(chatID: "gfhjsd", userID: "fdkjfb", displayName: "DEVISS DC")
      }
      .environmentObject(ChatsVM())
   }
}
