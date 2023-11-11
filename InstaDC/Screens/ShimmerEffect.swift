//
//  ShimmerEffect.swift
//  InstaDC
//
//  Created by IC Deis on 7/12/23.
//

import SwiftUI
import Shimmer

struct ShimmerEffect: View {
   let lowGray: Color = .gray.opacity(0.4)
   
   var body: some View {
      ScrollView {
        postEffect
        postEffect
      }
      .shimmering()
   }
}


extension ShimmerEffect {
   
   private var postEffect: some View {
      VStack(alignment: .leading, spacing: 0) {
         HStack {
            Circle()
               .fill(lowGray)
               .frame(width: 35, height: 35)
            RoundedRectangle(cornerRadius: 3)
               .fill(lowGray)
               .frame(width: 200, height: 20)
            Spacer()
            RoundedRectangle(cornerRadius: 3)
               .fill(lowGray)
               .frame(width: 20, height: 8)
         }
         .padding( 8)
         Rectangle()
            .fill(lowGray)
            .frame(height: 200)
         HStack(spacing: 20) {
            Image(systemName: "heart.fill")
            Image(systemName: "bubble.left.fill")
            Image(systemName: "paperplane.fill")
            Spacer()
         }
         .font(.title3)
         .padding(10)
         .foregroundColor(lowGray)
         VStack(alignment: .leading, spacing: 5) {
            RoundedRectangle(cornerRadius: 5)
               .fill(lowGray)
               .frame(width: 300, height: 15)
            RoundedRectangle(cornerRadius: 5)
               .fill(lowGray)
               .frame(width: 220, height: 15)
            
         }
         .padding(.horizontal, 10)
      }
      .padding(.bottom)
   }
   
}

struct ShimmerEffect_Previews: PreviewProvider {
   static var previews: some View {
      ShimmerEffect()
   }
}
