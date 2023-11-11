//
//  ShakenAnimation.swift
//  InstaDC
//
//  Created by IC Deis on 7/9/23.
//

import SwiftUI

struct ShakenAnimation: GeometryEffect {
   private var percent: CGFloat
   var animatableData: CGFloat {
      get { percent }
      set { percent = newValue }
   }
   
   init(animate: Bool) {
      percent = animate ? 3.5 : 0.0
   }
   
   func modifier(_ x: CGFloat) -> CGFloat {
      10 * sin(x * .pi * 2)
   }
   
   func effectValue(size: CGSize) -> ProjectionTransform {
      let transform = ProjectionTransform(CGAffineTransform.init(translationX: 0 + modifier(percent), y: 0))
      return transform
   }
}
