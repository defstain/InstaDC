//
//  SettingsEditPhotoVIew.swift
//  InstaDC
//
//  Created by IC Deis on 6/19/23.
//

import SwiftUI

struct SettingsEditPhotoVIew: View {
   @EnvironmentObject private var profileVM: ProfileVM
   @Environment(\.dismiss) private var dismiss
   let title: LocalizedStringKey
   let description: LocalizedStringKey
   
   @State private var showImagePicker: Bool = false
   
   var body: some View {
      VStack(alignment: .leading, spacing: 15) {
         
         Text(description)
            .fontWeight(.medium)
         
         ZStack(alignment: .bottom) {
            Image(uiImage: profileVM.selectedPhoto)
               .resizable()
               .scaledToFill()
               .frame(width: 250, height: 250, alignment: .center)
            
            Button {
               showImagePicker.toggle()
            } label: {
               Text(CommonLocale.edit)
                  .font(.callout)
                  .fontWeight(.medium)
                  .padding(.vertical, 10)
                  .frame(maxWidth: .infinity)
                  .foregroundColor(.primary)
                  .background(.thinMaterial)
            }
         }
         .clipShape(Circle())
         
         RoundedButton(label: CommonLocale.save, background: .blue, width: nil) {
            profileVM.updateProfilePhoto()
         }
         .opacity(profileVM.isLoading ? 0.1 : 1.0)
         .disabled(profileVM.isLoading)

         Spacer()
      }
      .navigationTitle(title)
      .padding()
      .fullScreenCover(isPresented: $showImagePicker) {
         ImagePicker(selectedImage: $profileVM.selectedPhoto, isImageSelected: .constant(true), sourceType: .constant(.photoLibrary))
      }
      .alert(profileVM.alertTitle, isPresented: $profileVM.showPhotoChangeAlert, actions: { }) {
         Text(profileVM.alertMessage)
      }
      .onChange(of: profileVM.success) { _ in
         dismiss()
      }
   }
}


//struct SettingsEditPhotoVIew_Previews: PreviewProvider {
//   static var previews: some View {
//      NavigationStack {
//         SettingsEditPhotoVIew(title: "Edit Profile Photo", description: "Here you can edit your profile photo")
//            .environmentObject(ProfileVM(userID: "", isMyProfile: true))
//      }
//   }
//}
