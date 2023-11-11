//
//  SettingsEditTextView.swift
//  InstaDC
//
//  Created by IC Deis on 6/19/23.
//

import SwiftUI

struct SettingsEditTextView: View {
   @EnvironmentObject private var profileVM: ProfileVM
   @Environment(\.dismiss) private var dismiss

   @Binding var input: String
   let title: LocalizedStringKey
   let description: LocalizedStringKey
   let placeholder: LocalizedStringKey
   let action: () -> ()
   
   var body: some View {
      VStack(alignment: .leading, spacing: 15) {
         Text(description)
            .fontWeight(.medium)
         
         TextField(placeholder, text: $input)
            .modifier(FullInput(background: .theme.gray.opacity(0.15)))
            .fontWeight(.medium)
            .autocorrectionDisabled()
         RoundedButton(label: ActionLocale.save, background: .blue, width: nil) {
            action()
         }
         .opacity(profileVM.isLoading ? 0.1 : 1.0)
         .disabled(profileVM.isLoading)
         
         Spacer()
      }
      .navigationTitle(title)
      .padding()
      .alert(profileVM.alertTitle, isPresented: $profileVM.showPhotoChangeAlert, actions: { }) {
         Text(profileVM.alertMessage)
      }
      .onChange(of: profileVM.success) { _ in
         dismiss()
      }
   }
}

//struct SettingsEditTextView_Previews: PreviewProvider {
//   static var previews: some View {
//      NavigationStack {
//         SettingsEditTextView(input: .constant(""), title: "Edit View", description: "Here you can edit your display name.",
//                              placeholder: "New display name", action: { })
//      }
//      .environmentObject(ProfileVM(userID: "", isMyProfile: true))
//   }
//}
