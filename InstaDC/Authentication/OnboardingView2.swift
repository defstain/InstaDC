//
//  OnboardingView2.swift
//  InstaDC
//
//  Created by IC Deis on 6/19/23.
//

import SwiftUI

struct OnboardingView2: View {
   @EnvironmentObject var authVM: AuthenticationVM
   
   @Binding var name: String
   @Binding var email: String
   @Binding var userID: String
   @Binding var provider: String
   
   @State private var showImagePicker: Bool = false
   @State private var isImageSelected: Bool = false
   let unText: LocalizedStringKey = AuthLocale.check_username_exist
   
   var body: some View {
      VStack(spacing: 20.0) {
         HStack {
            DismissButton(imageName: "xmark")
               .foregroundColor(.white)
            Spacer()
         }
         .padding(.top, 60)
         
         ZStack(alignment: .bottom) {
            if isImageSelected {
               Image(uiImage: authVM.selectedImage)
                  .resizable()
                  .scaledToFill()
                  .clipShape(Circle())
            } else {
               Circle()
                  .fill(.ultraThinMaterial)
            }
            Button {
               showImagePicker.toggle()
            } label: {
               Image(systemName: "photo")
                  .font(.title3)
                  .frame(maxWidth: .infinity)
                  .padding(8)
                  .foregroundColor(.black)
                  .background(.white.opacity(0.5))
                  
            }
         }
         .frame(width: 200, height: 200)
         .clipShape(Circle())
         .padding(.bottom, 30)
         
         
         Text(AuthLocale.whats_your_username)
            .font(.title3)
            .bold()
            .foregroundColor(.theme.yellow)
            .frame(maxWidth: .infinity, alignment: .leading)
         
         VStack(alignment: .leading) {
            TextField(AuthLocale.add_username_placeholder, text: $authVM.usernameInput)
               .modifier(FullInput(background: .theme.background))
               .autocorrectionDisabled()
            
            Text(authVM.usernameInput.isEmpty ? unText : authVM.checkUsernameInfo)
               .foregroundColor(authVM.usernameInput.isEmpty ? .white : (authVM.isUsernameExist ? .green : .red))
               .font(.callout)
               .minimumScaleFactor(0.8)
         }
         .onChange(of: authVM.usernameInput) { _ in
            authVM.isUsernameExist = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
               self.authVM.checkUsernameExistence()               
            }
         }
         Text(AuthLocale.whats_your_name)
            .font(.title3)
            .bold()
            .foregroundColor(.theme.yellow)
            .frame(maxWidth: .infinity, alignment: .leading)
         
         TextField(AuthLocale.add_your_name_placeholder, text: $authVM.nameInput)
            .modifier(FullInput(background: .theme.background))
            .autocorrectionDisabled()
         
         Spacer()

         RoundedButton(
            label: AuthLocale.finish,
            background: (!isImageSelected || authVM.nameInput.isEmpty || authVM.usernameInput.isEmpty || !authVM.isUsernameExist) ? .gray : .theme.green,
            width: nil) {
            authVM.makeNewUser()
         }
         .animation(.easeOut(duration: 0.2), value: name)
         .padding(.vertical)
         .disabled(!isImageSelected || !authVM.isUsernameExist || authVM.nameInput.isEmpty)
         
      }
      .padding()
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background { GradientView() }
      .ignoresSafeArea()
      .sheet(isPresented: $showImagePicker) {
         ImagePicker(selectedImage: $authVM.selectedImage, isImageSelected: $isImageSelected, sourceType: .constant(.photoLibrary))
      }
      .alert(AuthLocale.error_making_new_user, isPresented: $authVM.showAlertOnboarding2, actions: { } ) {
         Text(AuthLocale.could_not_make_new_user_profile)
      }
      .preferredColorScheme(.light)
   }
}


extension OnboardingView2 {

   
}

struct OnboardingView2_Previews: PreviewProvider {
   
   @State private static var test: String = "esta"
   
   static var previews: some View {
      OnboardingView2(name: $test, email: $test, userID: $test, provider: $test)
         .environmentObject(AuthenticationVM())
   }
}
