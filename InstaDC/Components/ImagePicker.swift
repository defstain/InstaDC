//
//  ImagePicker.swift
//  InstaDC
//
//  Created by IC Deis on 6/16/23.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
   @Environment(\.dismiss) private var dismiss
   @Binding var selectedImage: UIImage
   @Binding var isImageSelected: Bool
   @Binding var sourceType: UIImagePickerController.SourceType
   
   func makeCoordinator() -> Coordinator {
      return Coordinator(parent: self)
   }
   
   func makeUIViewController(context: Context) -> some UIImagePickerController {
      let picker = UIImagePickerController()
      picker.delegate = context.coordinator
      picker.sourceType = sourceType
      picker.allowsEditing = true
      return picker
   }
   
   func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
      
   }
   
}


extension ImagePicker {
   
   class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
      let parent: ImagePicker
      
      init(parent: ImagePicker) {
         self.parent = parent
      }
      
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         guard let image = info[.originalImage] as? UIImage else { return }
         parent.selectedImage = image
         parent.isImageSelected = true
         parent.dismiss()
      }
   }
   
}
