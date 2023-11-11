//
//  UploadView.swift
//  InstaDC
//
//  Created by IC Deis on 6/15/23.
//

import SwiftUI
import PhotosUI
import UIKit

struct UploadView: View {
   @EnvironmentObject var postVM: PostsVM
   @StateObject var vm = UploadVM()
   
//   @State private var pickerImageItem: PhotosPickerItem? = nil
   @State private var showImagePicker: Bool = false
   @State private var imagePickerType: UIImagePickerController.SourceType = .camera
   @State private var showOnboardingView: Bool = false
   @State private var showActions: Bool = false
   
   @AppStorage(UDKeys.uid) private var currentUserID: String?
   
   var body: some View {
      ZStack {
         backgroundView
         
         Button {
            showActions.toggle()
         } label: {
            Text(UploadLocale.upload)
               .font(.largeTitle)
               .fontWeight(.bold)
               .padding()
               .padding(.horizontal)
               .foregroundColor(.white)
               .cornerRadius(10)
         }
         .fullScreenCover(isPresented: $vm.showPostImageView) {
            UploadPostImageView(postImage: $vm.selectedImage)
               .environmentObject(vm)
         }
      }
      
      .confirmationDialog("Upload your photo or video", isPresented: $showActions) {
         Button(UploadLocale.from_camera) {
            if currentUserID != nil {
               imagePickerType = .camera
               showImagePicker.toggle()
            } else {
               postVM.showOnboardingView.toggle()
            }
         }
         
         
         Button(UploadLocale.from_library) {
            if currentUserID != nil {
               imagePickerType = .photoLibrary
               showImagePicker.toggle()
            } else {
               postVM.showOnboardingView.toggle()
            }
         }
         
         Button(CommonLocale.cancel, role: .cancel) { }
      }
      .sheet(isPresented: $showImagePicker, onDismiss: presentPostImageView) {
         ImagePicker(selectedImage: $vm.selectedImage, isImageSelected: $vm.isImageSelected, sourceType: $imagePickerType)
      }
      .toolbarBackground(.hidden, for: .tabBar)
      .toolbarColorScheme(.dark, for: .tabBar)
   }
}


extension UploadView {
   
   private var oldView: some View {
      VStack(spacing: 0) {
         takePhotoSection
         
         importPhotoSection
           
      }
   }
   
   private var backgroundView: some View {
      Image("gradient2")
         .resizable()
         .scaledToFill()
         .ignoresSafeArea()
   }
   
   private var takePhotoSection: some View {
      ZStack {
         Color.theme.yellow
         Button {
            if currentUserID != nil {
               imagePickerType = .camera
               showImagePicker.toggle()
            } else {
               postVM.showOnboardingView.toggle()
            }
         } label: {
            Text(UploadLocale.from_camera)
               .font(.largeTitle)
               .fontWeight(.bold)
               .foregroundColor(.theme.purple)
         }
         .offset(y: 30)
      }
   }
   
   private var importPhotoSection: some View {
      ZStack {
         Color.theme.purple
         Button {
            if currentUserID != nil {
               imagePickerType = .photoLibrary
               showImagePicker.toggle()
            } else {
               postVM.showOnboardingView.toggle()
            }
         } label: {
            Text(UploadLocale.from_library)
               .font(.largeTitle)
               .fontWeight(.bold)
               .foregroundColor(.theme.yellow)
         }
         .offset(y: -30)
      }
   }
   
   private func presentPostImageView() {
      guard vm.isImageSelected else { return }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
         vm.showPostImageView.toggle()
      }
   }
   
}

struct UploadView_Previews: PreviewProvider {
   static var previews: some View {
      UploadView()
   }
}
