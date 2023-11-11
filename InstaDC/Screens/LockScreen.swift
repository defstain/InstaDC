//
//  LockScreen.swift
//  InstaDC
//
//  Created by IC Deis on 7/9/23.
//

import SwiftUI
import LocalAuthentication

struct LockScreen: View {
   let numberColumns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
   let numbersArray = [1,2,3,4,5,6,7,8,9]
   
   @Environment(\.scenePhase) private var scenePhase
   
   @Binding var isLocked: Bool
   @State private var selectedNumbers: [Int] = []
   @State private var isKeyDisabled: Bool = false
   @State private var animate: Bool = false
   
   @AppStorage(PassKeys.useBiometric) private var useBiometric: Bool = false
   
   
   var body: some View {
      VStack(spacing: 20) {
         logoImage
         Text(LockLocale.enter_password)
            .font(.title3)
         
         inputCheckingCount
            .padding(.bottom, 40)
                  
         gridNumbersList
      }
      .onChange(of: selectedNumbers) { _ in
         checkPasswordInputs()
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(.regularMaterial)
      .onChange(of: scenePhase) { newPhase in
         if useBiometric && newPhase == .active {
            Task { try await requireBiometricAuth() }
         }
      }
      .ignoresSafeArea()
   }
}


extension LockScreen {
   
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
      .modifier(ShakenAnimation(animate: animate))
   }
   
   private var gridNumbersList: some View {
      LazyVGrid(columns: numberColumns, alignment: .center, spacing: 25) {
         ForEach(numbersArray, id: \.self) { index in
           circleNumberPad(index: index)
         }
         biometricButton
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
            .fill(Color.theme.grayLight)
            .frame(maxWidth: 80)
            .overlay {
               Text("\(index)")
                  .font(.title)
                  .fontWeight(.semibold)
                  .foregroundColor(.primary)
            }
      }
      .disabled(isKeyDisabled)
   }
   
   private var biometricButton: some View {
      Button {
         Task {
            try await requireBiometricAuth()
         }
      } label: {
         Image(systemName: "touchid")
            .font(.system(size: 65))
            .foregroundColor(.teal)
            .brightness(0.1)
            .frame(maxWidth: 80)
            .clipShape(Circle())
      }
      .opacity(useBiometric ? 1.0 : 0.0)
   }
   
   private func deleteButton() -> some View {
      Button {
         guard !selectedNumbers.isEmpty else { return }
         selectedNumbers.removeLast()
      } label: {
         Image(systemName: "delete.backward.fill")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 30)
            .foregroundColor(.primary)
      }
      .disabled(selectedNumbers.isEmpty)
   }
   
}

extension LockScreen {
   
   private func checkPasswordInputs() {
      if selectedNumbers.count > 3 {
         isKeyDisabled = true
         guard let currentPass = UserDefaults.standard.array(forKey: PassKeys.currentpass) as? [Int] else { return }
         if currentPass == selectedNumbers {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
               withAnimation(.spring()) {
                  isLocked = false                  
                  selectedNumbers.removeAll()
                  isKeyDisabled = false
               }
            }
         } else {
            withAnimation(.linear(duration: 0.6)) {
               animate = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
               animate = false
               selectedNumbers.removeAll()
               isKeyDisabled = false
            }
         }
      }
   }
   
   private func requireBiometricAuth() async throws {
      let context = LAContext()
      var error: NSError?
      
      if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
         let reason = "We need to unlock your data."
         let result = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
         if result {
            isLocked = false
         }
      }
   }
   
}

struct LockScreen_Previews: PreviewProvider {
   static var previews: some View {
      LockScreen(isLocked: .constant(true))
   }
}
