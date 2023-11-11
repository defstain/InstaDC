//
//  SettingsRowView.swift
//  InstaDC
//
//  Created by IC Deis on 6/18/23.
//

import SwiftUI

struct SettingsRowView: View {
   let icon: String
   let background: Color
   let label: LocalizedStringKey
   
   var body: some View {
      HStack {
         background
            .frame(width: 32, height: 32)
            .cornerRadius(5)
            .overlay {
               Image(systemName: icon)
                  .font(.title3)
                  .foregroundColor(.white)
            }
         Text(label)
            .fontWeight(.medium)
            .foregroundColor(.primary)
         Spacer()
         Image(systemName: "chevron.forward")
            .font(.headline)
            .foregroundColor(.primary)
      }
      .padding(.vertical, 5)
   }
}

struct SettingsRowView_Previews: PreviewProvider {
   static var previews: some View {
      SettingsRowView(icon: "snowflake", background: .orange, label: "Change display name")
   }
}

