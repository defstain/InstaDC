//
//  SettingsView.swift
//  InstaDC
//
//  Created by IC Deis on 6/18/23.
//

import SwiftUI

struct SettingsView: View {
   @EnvironmentObject private var authVM: AuthenticationVM
   @EnvironmentObject private var profileVM: ProfileVM
   
   @Environment(\.openURL) private var openURL
   @Environment(\.dismiss) private var dismiss
   @Environment(\.colorScheme) private var colorSchema
   
   @State private var isLocked: Bool = false
   @State private var showSignOutSheet: Bool = false
   
   @AppStorage("app_locale") var appLocale: String = "en"
   @AppStorage(PassKeys.showLockScreen) private var showLockScreen: Bool = false
   
   
   var body: some View {
      NavigationStack {
         ScrollView(showsIndicators: false) {
            
            // MARK: - About App
            aboutAppSection
            
            // MARK: - Profile
            editProfileSection
            
            // MARK: - App Policy
            appPolicySection
            
            // MARK: - App Ownership
            aboutAppOwnershipSection
            
         }
         .navigationTitle(SettingLocale.settings)
         .toolbar { dismissButtonInToolbar }
      }
      .environmentObject(profileVM)
      .onAppear {
         isLocked = UserDefaults.standard.bool(forKey: PassKeys.showLockScreen)
      }
      .confirmationDialog("", isPresented: $showSignOutSheet) {
         Button(SettingLocale.sign_out, role: .destructive) {
            signOut()
         }
         Button(CommonLocale.cancel, role: .cancel) { }
      }
   }
}


extension SettingsView {
   
   private var aboutAppSection: some View {
      GroupBox {
         HStack(spacing: 10) {
            Image("plant-logo")
               .resizable()
               .scaledToFit()
               .frame(width: 60, height: 60)
            
            Text(SettingLocale.about_app)
               .font(.footnote)
         }
      } label: {
         SettingsLabelView(label: "Insta DC", icon: "tornado")
      }
      .padding(10)
   }
   
   private var editProfileSection: some View {
      GroupBox {
         NavigationLink {
            SettingsEditPhotoVIew(title: SettingLocale.edit_profile_photo,
                                  description: SettingLocale.edit_profile_photo_description)
         } label: {
            SettingsRowView(icon: "photo", background: .mint.opacity(0.7), label: SettingLocale.profile_photo)
         }
         
         NavigationLink {
            SettingsEditTextView(input: $profileVM.username, title: SettingLocale.edit_username,
                                 description: SettingLocale.edit_username_description, placeholder: SettingLocale.edit_username_placeholder) {
               profileVM.updateUsername()
            }
         } label: {
            SettingsRowView(icon: "at", background: .blue.opacity(0.6), label: SettingLocale.username)
         }
         
         NavigationLink {
            SettingsEditTextView(input: $profileVM.displayName, title: SettingLocale.edit_display_name,
                                 description: SettingLocale.edit_display_name_description, placeholder: SettingLocale.edit_display_name_placeholder) {
               profileVM.updateDisplayName()
            }
         } label: {
            SettingsRowView(icon: "pencil", background: .green, label: SettingLocale.display_name)
         }
         
         NavigationLink {
            SettingsEditTextView(input: $profileVM.bio, title: SettingLocale.edit_bio,
                                 description: SettingLocale.edit_bio_description, placeholder: SettingLocale.edit_bio_placeholder) {
               profileVM.updateUserBio()
            }
         } label: {
            SettingsRowView(icon: "text.badge.checkmark", background: .orange, label: SettingLocale.bio)
         }
         
         NavigationLink {
            ChangeAppLocaleView(locale: getEnumType(value: appLocale))
         } label: {
            SettingsRowView(icon: "globe", background: .blue, label: SettingLocale.app_language)
         }
         
         NavigationLink {
            if isLocked {
               LockScreen(isLocked: $isLocked)
            } else {
               SetPasswordView(isLocked: $isLocked)
            }
         } label: {
            SettingsRowView(icon: "lock", background: .black, label: SettingLocale.app_password)
         }
         
         Button {
            showSignOutSheet.toggle()
         } label: {
            SettingsRowView(icon: "arrow.uturn.left", background: .pink, label: SettingLocale.sign_out)
         }
         
      } label: {
         SettingsLabelView(label: MainLocale.profile, icon: "sparkles")
      }
      .padding(10)
   }
   
   private var appPolicySection: some View {
      GroupBox {
         Button {
            openLinksInSafari(urlString: "https://www.apple.com")
         } label: {
            SettingsRowView(icon: "tornado", background: .indigo, label: SettingLocale.website)
         }
         
         Button {
            openLinksInSafari(urlString: "https://www.google.com")
         } label: {
            SettingsRowView(icon: "text.aligncenter", background: .black, label: SettingLocale.privacy_policy)
         }
         
         Button {
            openLinksInSafari(urlString: "https://www.youtube.com")
         } label: {
            SettingsRowView(icon: "text.aligncenter", background: .black, label: SettingLocale.condition_and_terms)
         }
  
      } label: {
         SettingsLabelView(label: SettingLocale.application, icon: "apps.iphone")
      }
      .padding(10)
   }
   
   private var aboutAppOwnershipSection: some View {
      GroupBox {
         Text(SettingLocale.footer_app_description)
            .fontWeight(.semibold)
            .foregroundColor(.theme.gray)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .lineSpacing(5)
      }
      .padding(10)
      .padding(.bottom, 30)
   }
   
   private var dismissButtonInToolbar: ToolbarItem<(), some View> {
      ToolbarItem(placement: .navigationBarTrailing) {
         DismissButton(imageName: "xmark")
      }
   }
   
   // MARK: - Functions
   
   private func openLinksInSafari(urlString: String) {
      guard let url = URL(string: urlString) else { return }
      openURL(url)
   }
   
   private func signOut() {
      authVM.signOut()
      dismiss()
   }
   
   private func getEnumType(value: String) -> AppLocale {
      switch value {
      case AppLocale.en.rawValue: return .en
      case AppLocale.uz.rawValue: return .uz
      default: return .en
      }
   }
}

prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
   Binding<Bool>(
      get: { !value.wrappedValue },
      set: { value.wrappedValue = !$0 }
   )
}


//struct SettingsView_Previews: PreviewProvider {
//   static var previews: some View {
//      NavigationStack {
//         SettingsView()
//            .environmentObject(AuthenticationVM())
//            .environmentObject(ProfileVM(userID: "", isMyProfile: true))
//      }
//   }
//}
