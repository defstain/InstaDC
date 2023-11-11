//
//  SignInWithAppleButton.swift
//  InstaDC
//
//  Created by IC Deis on 6/19/23.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleButton: UIViewRepresentable {
   
   func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
      return ASAuthorizationAppleIDButton.init(type: .default, style: .black)
   }
   
   func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) { }
   
}
