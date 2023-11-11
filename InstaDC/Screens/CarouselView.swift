//
//  CarouselView.swift
//  InstaDC
//
//  Created by IC Deis on 6/13/23.
//

import SwiftUI

struct CarouselView: View {
   @State private var selectedTab: Int = 0
   @State private var isTimerRunning: Bool = false
//   private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
   
   let posts: [Post]
   
   var body: some View {
      TabView(selection: $selectedTab) {
         ForEach(Array(posts.enumerated()), id: \.offset) { index, post in
            PostView(post: post, showDetails: false)
               .frame(width: UIDevice.current.userInterfaceIdiom == .pad
                      ? nil : UIScreen.main.bounds.width)
               .clipped()
               .tag(index)
         }
      }
      .tabViewStyle(.page)
      .frame(height: 280)
      .animation(.default, value: selectedTab)
      .onAppear {
         if !isTimerRunning {
            setTimer()  
         }
      }
   }
}


extension CarouselView {
   
   private func setTimer() {
      self.isTimerRunning = true
      let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
         selectedTab = selectedTab >= 10 ? 0 : selectedTab + 1
      }
      timer.fire()
   }
   
}

struct CarouselView_Previews: PreviewProvider {
   static var previews: some View {
      CarouselView(posts: dev.posts)
   }
}
