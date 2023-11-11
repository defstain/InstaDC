//
//  LazyView.swift
//  InstaDC
//
//  Created by IC Deis on 6/29/23.
//

import SwiftUI

/// Generic struct to meke view lazy
struct LazyView<Content: View>: View {
   let content: () -> Content
   
   var body: some View {
      self.content()
   }
   
}
