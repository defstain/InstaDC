//
//  LikeAnimationView.swift
//  InstaDC
//
//  Created by IC Deis on 6/20/23.
//

import SwiftUI

struct LikeAnimationView: View {
   @Binding var animate: Bool
   
   var body: some View {
      ZStack {
         Image(systemName: "heart.fill")
            .font(.system(size: 200))
            .foregroundColor(.red.opacity(0.5))
            .opacity(animate ? 1.0 : 0.0)
            .scaleEffect(animate ? 1.0 : 0.2)
         
         Image(systemName: "heart.fill")
            .font(.system(size: 150))
            .foregroundColor(.red.opacity(0.7))
            .opacity(animate ? 1.0 : 0.0)
            .scaleEffect(animate ? 1.0 : 0.4)
         
         Image(systemName: "heart.fill")
            .font(.system(size: 100))
            .foregroundColor(.red)
            .opacity(animate ? 1.0 : 0.0)
            .scaleEffect(animate ? 1.0 : 0.6)
      }
      .animation(.easeIn(duration: 0.5), value: animate)
   }
}

struct LikeAnimationView_Previews: PreviewProvider {
   static var previews: some View {
      LikeAnimationView(animate: .constant(false))
   }
}
