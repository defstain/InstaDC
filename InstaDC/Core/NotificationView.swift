//
//  NotificationView.swift
//  InstaDC
//
//  Created by IC Deis on 9/8/23.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
       ScrollView {
          VStack {
             if #available(iOS 16, *) {
                ZStack {
                   
                }
             } else {
                Text("")
             }
          }
       }
       .overlay {
          Text(NotificationLocale.no_notifications)
       }
       .background(.orange.opacity(0.5))
       .navigationTitle("Notifications")
       .navigationBarTitleDisplayMode(.inline)
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
       NavigationStack {
          NotificationView()
       }
    }
}
