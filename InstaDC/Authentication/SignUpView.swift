//
//  SignUpView.swift
//  InstaDC
//
//  Created by IC Deis on 6/19/23.
//

import SwiftUI

struct SignUpView: View {
   @EnvironmentObject var authVM: AuthenticationVM
   @State private var showOnboardingView: Bool = false
   
   var body: some View {
      VStack(spacing: 20) {
         Spacer()
         LogoView()
         
         Text(AuthLocale.you_are_not_signed_in)
            .font(.title)
            .bold()
            .lineLimit(1)
            .minimumScaleFactor(0.7)
         Text(AuthLocale.click_the_button_below)
            .font(.headline)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
         
         RoundedButton(label: AuthLocale.sign_in_sign_up, background: .theme.green, width: nil) {
            
            showOnboardingView.toggle()
         }
         .padding(.top, 50)
         
         
         Spacer()
      }
      .foregroundColor(.white)
      .padding(30)
      .offset(y: -30)
      .background { GradientView() }
      .frame(maxHeight: .infinity)
      .ignoresSafeArea(edges: .top)
      .fullScreenCover(isPresented: $showOnboardingView) {
         OnboardingView()
            .environmentObject(authVM)
      }
      .toolbarBackground(.hidden, for: .tabBar)
      .toolbarColorScheme(.dark, for: .tabBar)
   }
}

struct SignUpView_Previews: PreviewProvider {
   static var previews: some View {
      SignUpView()
         .environmentObject(AuthenticationVM())
   }
}
