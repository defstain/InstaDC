//
//  LoadingView.swift
//  InstaDC
//
//  Created by IC Deis on 6/26/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
       ZStack {
          Color.gray.opacity(0.4)
             .ignoresSafeArea()
          
          ProgressView()
             .scaleEffect(1.5)
       }
       .allowsHitTesting(false)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
