//
//  MessageRowView.swift
//  InstaDC
//
//  Created by IC Deis on 7/15/23.
//

import SwiftUI

struct MessageRowView: View {
   let userID: String
   
   var body: some View {
      HStack {
         ProfilePhoto(userID: userID)
         VStack {
            
         }
      }
   }
}

struct MessageRowView_Previews: PreviewProvider {
   static var previews: some View {
      MessageRowView(userID: "dkvyf")
   }
}
