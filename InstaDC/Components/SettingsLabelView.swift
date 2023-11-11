//
//  SettingsLabelView.swift
//  InstaDC
//
//  Created by IC Deis on 6/18/23.
//

import SwiftUI

struct SettingsLabelView: View {
   let label: LocalizedStringKey
   let icon: String
   
   var body: some View {
      VStack {
         HStack {
            Text(label)
               .bold()
            Spacer()
            
            Image(systemName: icon)
         }
         Divider()
      }
   }
}

struct SettingsLabelView_Previews: PreviewProvider {
   static var previews: some View {
      SettingsLabelView(label: "List View", icon: "arrow.forward")
   }
}
