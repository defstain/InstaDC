//
//  GradientView.swift
//  InstaDC
//
//  Created by IC Deis on 9/7/23.
//

import SwiftUI

struct GradientView: View {
    var body: some View {
       ZStack {
          Image("gradient")
             .resizable()
             .scaledToFill()
             .ignoresSafeArea()
       }
    }
}

struct GradientView_Previews: PreviewProvider {
    static var previews: some View {
        GradientView()
    }
}
