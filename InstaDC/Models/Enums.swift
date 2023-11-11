//
//  Enums.swift
//  InstaDC
//
//  Created by IC Deis on 7/6/23.
//

import SwiftUI

enum AppLocale: String, CaseIterable {
   case en
   case uz
   
   var description: String {
      switch self {
      case .en: return "English"
      case .uz: return "O'zbek"
      }
   }
}

enum PassRequirementTime: String, CaseIterable {
   case one
   case three
   case five
   case immediately
   
   var description: LocalizedStringKey {
      switch self {
      case .one: return SettingLocale.minute_1
      case .three: return SettingLocale.minutes_3
      case .five: return SettingLocale.minutes_5
      case .immediately: return SettingLocale.immediately
      }
   }
   
   var count: Int {
      switch self {
      case .one: return 120
      case .three: return 360
      case .five: return 600
      case .immediately: return 1
      }
   }
}
