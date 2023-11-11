//
//  SetLockScreenView.swift
//  InstaDC
//
//  Created by IC Deis on 7/10/23.
//

import SwiftUI

struct SetLockScreenView: View {
   @Environment(\.dismiss) private var dismiss
   let numberColumns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
   let numbersArray = [1,2,3,4,5,6,7,8,9]
   
   @State private var firstPass: [Int] = []
   @State private var confirmedPass: [Int] = []
   @State private var showConfirmButton: Bool = false
   
   @State private var selectedNumbers: [Int] = []
   @State private var isKeyDisabled: Bool = false
   @State private var animate: Bool = false
   @State private var alertMessage: LocalizedStringKey = "message"
   
   
   var body: some View {
      NavigationStack {
         VStack(spacing: 10) {
            logoImage
            Text(LockLocale.enter_password)
               .font(.title3)
            
            inputCheckingCount
            Text(alertMessage)
               .foregroundColor(.pink)
               .opacity(animate ? 1.0 : 0.0)
               .padding(.bottom, 20)
            
            gridNumbersList
         }
         .onChange(of: selectedNumbers) { _ in
            checkPasswordInputs()
         }
         .frame(maxWidth: .infinity, maxHeight: .infinity)
         .background(.regularMaterial)
         .ignoresSafeArea()
         .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
               Button(CommonLocale.cancel) {
                  dismiss()
                  clearAll()
               }
            }
            if !firstPass.isEmpty {
               ToolbarItem(placement: .navigationBarTrailing) {
                  if showConfirmButton {
                     Button(CommonLocale.confirm) {
                        confirmPassword()
                     }
                  }
                  if !confirmedPass.isEmpty {
                     Button(CommonLocale.save) {
                        savePassword()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                           dismiss()
                           clearAll()
                        }
                     }
                  }
               }
            }
      }
      }
   }
}


extension SetLockScreenView {
   
   private var logoImage: some View {
      Image("plant-logo")
         .resizable()
         .scaledToFit()
         .frame(width: 100, height: 100)
         .padding(.bottom, 40)
         .padding(.top, 20)
   }
   
   private var inputCheckingCount: some View {
      HStack(spacing: 20) {
         ForEach(0..<4) { item in
            if item < selectedNumbers.count {
               Circle()
                  .frame(width: 20)
            } else {
               Circle()
                  .stroke(style: StrokeStyle(lineWidth: 1.5))
                  .frame(width: 20)
            }
         }
      }
      .padding(.vertical, 8)
      .modifier(ShakenAnimation(animate: animate))
   }
   
   private var gridNumbersList: some View {
      LazyVGrid(columns: numberColumns, alignment: .center, spacing: 25) {
         ForEach(numbersArray, id: \.self) { index in
            circleNumberPad(index: index)
         }
         Button {
            clearAll()
         } label: {
            Image(systemName: "gobackward")
               .resizable()
               .scaledToFit()
               .frame(maxWidth: 30)
               .foregroundColor(.black)
               .opacity(selectedNumbers.count > 3 ? 1.0 : 0.0)
         }
         circleNumberPad(index: 0)
         deleteButton()
      }
      .padding(.horizontal, 30)
   }
   
   private func circleNumberPad(index: Int) -> some View {
      Button {
         selectedNumbers.append(index)
      } label: {
         Circle()
            .fill(.teal.opacity(0.2))
            .frame(maxWidth: 70)
            .overlay {
               Text("\(index)")
                  .font(.title)
                  .fontWeight(.semibold)
                  .foregroundColor(.black)
            }
      }
      .disabled(isKeyDisabled)
   }
   
   private func deleteButton() -> some View {
      Button {
         if selectedNumbers.isEmpty { return }
         selectedNumbers.removeLast()
      } label: {
         Image(systemName: "delete.backward.fill")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 30)
            .foregroundColor(.black)
      }
      .disabled(selectedNumbers.isEmpty || selectedNumbers.count == 4)
   }
   
}

extension SetLockScreenView {
   
   private func checkPasswordInputs() {
      if selectedNumbers.count > 3 {
         isKeyDisabled = true
         if firstPass.isEmpty {
            showConfirmButton.toggle()
            firstPass = selectedNumbers
         } else {
            if selectedNumbers == firstPass {
               confirmedPass = selectedNumbers
            } else {
               withAnimation(.linear(duration: 0.6)) {
                  alertMessage = LockLocale.password_did_not_match
                  animate.toggle()
               }
            }
         }
         
      }
   }
   
   private func confirmPassword() {
      showConfirmButton = false
      selectedNumbers.removeAll()
      isKeyDisabled = false
   }
   
   private func savePassword() {
      UserDefaults.standard.set(confirmedPass, forKey: PassKeys.currentpass)
      UserDefaults.standard.set(true, forKey: PassKeys.showLockScreen)
   }
   
   private func clearAll() {
      firstPass.removeAll()
      confirmedPass.removeAll()
      selectedNumbers.removeAll()
      
      animate = false
      showConfirmButton = false
      isKeyDisabled = false
   }
   
}

struct SetLockScreenView_Previews: PreviewProvider {
   static var previews: some View {
      SetLockScreenView()
   }
}
