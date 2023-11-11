//
//  TiltAnimation.swift
//  InstaDC
//
//  Created by IC Deis on 7/9/23.
//

import SwiftUI

struct TiltAnimtation: GeometryEffect {
   private var percent: CGFloat
   var animatableData: CGFloat {
      get { percent }
      set { percent = newValue }
   }
   
   init(isOn: Bool) {
      self.percent = isOn ? 1.0 : 0.0
   }
   
   func effectValue(size: CGSize) -> ProjectionTransform {
      guard percent != 0, percent != 1 else { return ProjectionTransform(.identity) }
      let anchorPointTransform = CGAffineTransform.init(translationX: -size.width / 2, y: -size.height / 2)
      var tiltingTransform = CGAffineTransform.identity
      
      let maxTilt: CGFloat = 0.25
      if percent < 0.25 {
         tiltingTransform.b = maxTilt * percent
      } else if percent < 0.5 {
         tiltingTransform.b = maxTilt * (percent - 0.25) / 0.25
      } else if percent < 0.5 {
         tiltingTransform.b = maxTilt * (percent - 0.5) / 0.25 * 0.5
      } else {
         tiltingTransform.b = maxTilt * (percent - 0.75) / 0.25 * 0.5
      }
      
      return ProjectionTransform(anchorPointTransform.concatenating(tiltingTransform))
         .concatenating(ProjectionTransform(.init(translationX: size.width / 2, y: size.height / 2)))
   }
}



