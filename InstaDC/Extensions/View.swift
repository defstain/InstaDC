//
//  View.swift
//  InstaDC
//
//  Created by IC Deis on 7/24/23.
//

import SwiftUI
import UIKit

extension View {
   
   /// This function rounds the specified corner
   func cornerRadius (_ radius: CGFloat, corners: UIRectCorner) -> some View {
      clipShape(RoundedCorner(radius: radius, corners: corners) )
   }
}


struct RoundedCorner: Shape {
   var radius: CGFloat = .infinity
   var corners: UIRectCorner = .allCorners
   
   func path(in rect: CGRect) -> Path {
      let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize (width: radius, height: radius))
      return Path(path.cgPath)
   }
}

extension UIView {
   
   @IBInspectable var cornerRadius: CGFloat {
      get { return self.cornerRadius }
      set { self.layer.cornerRadius = newValue }
   }

}
