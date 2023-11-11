//
//  DismissButton.swift
//  InstaDC
//
//  Created by IC Deis on 6/16/23.
//

import SwiftUI

struct DismissButton: View {
   @Environment(\.dismiss) private var dismiss
   let imageName: String
   
    var body: some View {
       Button {
          dismiss()
       } label: {
          Image(systemName: imageName)
             .font(.headline)
       }

    }
}

struct DismissButton_Previews: PreviewProvider {
    static var previews: some View {
       DismissButton(imageName: "xmark")
    }
}
