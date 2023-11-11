//
//  CustomModifiers.swift
//  InstaDC
//
//  Created by IC Deis on 6/19/23.
//

import SwiftUI

struct FullInput: ViewModifier {
   let background: Color
   
   func body(content: Content) -> some View {
      content
         .padding()
         .background(background)
         .cornerRadius(10)
   }
}
