//
//  RoundedButton.swift
//  InstaDC
//
//  Created by IC Deis on 6/19/23.
//

import SwiftUI

struct RoundedButton: View {
   let label: LocalizedStringKey
   let background: Color
   let width: CGFloat?
   let action: () -> ()
   
   var body: some View {
      Button {
         action()
      } label: {
         Text(label)
            .font(.headline)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .frame(width: width)
            .foregroundColor(.white)
            .background(background)
            .cornerRadius(12)
      }
   }
}

struct RoundedButton_Previews: PreviewProvider {
   static var previews: some View {
      RoundedButton(label: "Save", background: .blue, width: 300, action: { })
   }
}
