//
//  LogoView.swift
//  InstaDC
//
//  Created by IC Deis on 6/19/23.
//

import SwiftUI

struct LogoView: View {
   var body: some View {
      Image("plant-logo")
         .resizable()
         .scaledToFit()
         .frame(width: 130, height: 130)
   }
}

struct LogoView_Previews: PreviewProvider {
   static var previews: some View {
      LogoView()
   }
}
