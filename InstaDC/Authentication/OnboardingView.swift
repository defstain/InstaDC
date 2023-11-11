//
//  OnboardingView.swift
//  InstaDC
//
//  Created by IC Deis on 6/19/23.
//

import SwiftUI
import FirebaseAuth

struct OnboardingView: View {
   @EnvironmentObject var authVM: AuthenticationVM
   @Environment(\.dismiss) private var dismiss
   
   @State private var showOnboardingView2: Bool = false
   @State var showErrorAlert: Bool = false
   
   @State var name: String = ""
   @State var email: String = ""
   @State var userID: String = ""
   @State var provider: String = ""
   
   var body: some View {
      VStack(spacing: 20) {
         LogoView()
         headerTextViews
         
         // MARK: - Sign in with Apple
         appleButton
         
         // MARK: - Sign in with Google
         googleButton
         
         // MARK: - Continue as a Guest
         guestButton
         
      }
      .padding(20)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background { GradientView() }
      .fullScreenCover(isPresented: $authVM.showOnboardingView2, onDismiss: {
         if !authVM.isSignedUp {
            authVM.signOut()
         }
      }) {
         OnboardingView2(name: $name, email: $email, userID: $userID, provider: $provider)
            .environmentObject(authVM)
      }
      .alert(AuthLocale.error_signing_in, isPresented: $authVM.showAlertOnboarding) { } message: {
         Text(AuthLocale.could_not_sign_in)
      }
      .onChange(of: authVM.isSignedUp) { _ in
         showOnboardingView2 = false
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            dismiss()
         }
      }
   }
}


extension OnboardingView {
   
   private var headerTextViews: some View {
      Group {
         Text(AuthLocale.welcome_to_app)
            .font(.title)
            .bold()
            .lineLimit(1)
            .minimumScaleFactor(0.7)
         
         Text(SettingLocale.about_app)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(.bottom, 20)
      }
      .foregroundColor(.white)
   }
   
   private var appleButton: some View {
      Button {
         SignInWithApple.shared.startSignInWithAppleFlow()
      } label: {
         SignInWithAppleButton()
            .frame(height: 55)
      }
      .disabled(true)
   }
   
   private var googleButton: some View {
      Button {
         Task {
            try await authVM.signInWithGoogle()
         }
      } label: {
         HStack(spacing: 45) {
            Image("google-logo")
               .resizable().scaledToFit()
               .padding(12)
               .frame(width: 50, height: 50)
               .background(.white)
               .cornerRadius(5)
               .offset(x: 3)
            Text("Sign in with Google")
         }
         .font(.system(size: 21, weight: .medium))
         .frame(height: 55)
         .frame(maxWidth: .infinity, alignment: .leading)
         .foregroundColor(.white)
         .background(.blue)
         .brightness(0.10)
         .cornerRadius(6)
      }
   }
   
   private var guestButton: some View {
      Button {
         dismiss()
      } label: {
         Text(AuthLocale.continue_as_guest)
            .font(.title2)
            .fontWeight(.semibold)
      }
      .foregroundColor(.blue)
      .brightness(0.4)
      .padding()
   }
   
}

extension OnboardingView {
   
//   func connectToFirebase(name: String, email: String, provider: String, credential: AuthCredential) {
//      Task {
//         do {
//            let result = try await UserManager.shared.signInUser(credential: credential)
//
//            if result.isExist {
//               authVM.signInToApp(uid: result.uid)
//            } else {
//               self.name = name
//               self.email = email
//               self.provider = provider
//               self.userID = result.uid
//               showOnboardingView2 = true
//            }
//         } catch {
//            print(("DEBUG: Could not sign in"))
//            showErrorAlert.toggle()
//         }
//      }
//   }
   
}

struct OnboardingView_Previews: PreviewProvider {
   static var previews: some View {
      OnboardingView()
         .environmentObject(AuthenticationVM())
   }
}
