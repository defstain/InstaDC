//
//  Numbers.swift
//  InstaDC
//
//  Created by IC Deis on 6/17/23.
//

import Foundation

extension Double {
   
   /// Returns the double value as a string
   func asString() -> String {
      String(self)
   }
   
   /// Returns the double value as a string with 2 decimal
   func asStringDecimal2() -> String {
      let num = self.asString()
      return String(format: "%.2f", num)
   }
   
}


extension Int {
   
   /// Returns the integer value as a string
   func asString() -> String {
      String(self)
   }
   
}
