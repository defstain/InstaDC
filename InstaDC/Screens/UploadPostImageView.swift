//
//  UploadPostImageView.swift
//  InstaDC
//
//  Created by IC Deis on 6/16/23.
//

import SwiftUI

struct UploadPostImageView: View {
   @EnvironmentObject private var vm: UploadVM
   @Environment(\.dismiss) private var dismiss
   
   @Binding var postImage: UIImage
   @State private var caption: String = ""
   @State private var showAlert: Bool = false
   
   var body: some View {
      NavigationStack {
         VStack {
               Image(uiImage: postImage)
                  .resizable()
                  .scaledToFill()
                  .frame(width: 200, height: 200)
                  .cornerRadius(12)
                  .clipped()
      
            TextField(UploadLocale.type_something_placeholder, text: $caption)
                  .font(.headline)
                  .padding()
                  .background(.ultraThinMaterial)
                  .cornerRadius(10)
                  .padding()
                  .textInputAutocapitalization(.sentences)
               
               Button {
                  vm.publishPost(caption: caption) 
               } label: {
                  Text(UploadLocale.publish)
                     .font(.headline)
                     .frame(height: 55)
                     .frame(maxWidth: .infinity)
                     .foregroundColor(.white)
                     .background(Color.theme.purple)
                     .cornerRadius(10)
               }
               .padding(.horizontal)
               .opacity(vm.isLoading ? 0.1 : 1.0)
               .disabled(vm.isLoading)
            
            Spacer()
         }
         .toolbar {
            ToolbarItem(placement: .navigationBarLeading) { DismissButton(imageName: "xmark")}
         }
         .alert(vm.alertTitle, isPresented: $vm.showAlert, actions: { }) {
            Text(vm.alertMessage)
         }
      }
   }
}

struct UploadPostImageView_Previews: PreviewProvider {
   static var previews: some View {
      UploadPostImageView(postImage: .constant(UIImage(named: "cars-4")!))
         .environmentObject(UploadVM())
   }
}
