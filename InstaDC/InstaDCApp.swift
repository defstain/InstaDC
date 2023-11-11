//
//  InstaDCApp.swift
//  InstaDC
//
//  Created by IC Deis on 7/15/23.
//

import SwiftUI
import FirebaseCore

@main
struct InstaDCApp: App {
   @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
   
//   init() {
//      UITabBar.appearance().unselectedItemTintColor = .white
//   }
   
   var body: some Scene {
      WindowGroup {
         ContentView()
      }
   }
}


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions
                   launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
     
  }
}
