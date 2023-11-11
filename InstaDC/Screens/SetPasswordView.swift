//
//  SetPasswordView.swift
//  InstaDC
//
//  Created by IC Deis on 7/9/23.
//

import SwiftUI

struct SetPasswordView: View {
   @Environment(\.dismiss) private var dismiss

   @State private var showSetPasswodView: Bool = false
   @State private var showDeletePasswordSheet: Bool = false
   @State private var useBiometricToggle: Bool = false
   @State private var password: [Int] = []
   
   @Binding var isLocked: Bool
   
   @AppStorage(PassKeys.passTimeRequirement) private var passTime: Int = 0
   @AppStorage(PassKeys.showLockScreen) private var showLockScreen: Bool = false
   @AppStorage(PassKeys.useBiometric) private var useBiometric: Bool = false
   
  
   var body: some View {
      VStack {
         List {
            timeSelection
            useBiometricSection
            setPasswordButton
               .fullScreenCover(isPresented: $showSetPasswodView) {
                  SetLockScreenView()
               }
            if showLockScreen {
               Button(role: .destructive) {
                  showDeletePasswordSheet.toggle()
               } label: {
                  Text(SettingLocale.delete_password)
               }
            }
         }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Material.regularMaterial)
      .navigationTitle(SettingLocale.set_password)
      .toolbar { doneButton }
      .onChange(of: useBiometricToggle) { useBiometric = $0 }
      .onAppear { useBiometricToggle = useBiometric }
      .onDisappear { isLocked = UserDefaults.standard.bool(forKey: PassKeys.showLockScreen) }
      .confirmationDialog("Delete Password", isPresented: $showDeletePasswordSheet) {
         Button(CommonLocale.delete, role: .destructive) { deleteAppPassword() }
         Button(CommonLocale.cancel, role: .cancel) { }
      }
   }
}


extension SetPasswordView {
   
   private var timeSelection: some View {
      Section(SettingLocale.select_time) {
         ForEach(PassRequirementTime.allCases, id: \.rawValue) { option in
            HStack {
               Text(option.description)
               Spacer()
               if passTime == option.count {
                  Image(systemName: "checkmark")
                     .foregroundColor(.blue)
               }
            }
            .background(.white.opacity(0.00001))
            .onTapGesture {
               passTime = option.count
            }
         }
      }
   }
   
   private var useBiometricSection: some View {
      Section {
         Toggle(isOn: $useBiometricToggle) {
            Text(SettingLocale.use_biometric)
         }
      }
   }
   
   private var setPasswordButton: some View {
      Button {
         showSetPasswodView.toggle()
      } label: {
         Text(showLockScreen ? SettingLocale.change_password : SettingLocale.set_password_2)
      }
   }
   
   private var doneButton: ToolbarItem<(), some View> {
      ToolbarItem(placement: .navigationBarTrailing) {
         Button(CommonLocale.done) {
            UserDefaults.standard.setValue(passTime, forKey: PassKeys.passTimeRequirement)
            dismiss()
         }
         .foregroundColor(.blue)
      }
   }
   
}

extension SetPasswordView {
   
   private func deleteAppPassword() {
      UserDefaults.standard.removeObject(forKey: PassKeys.showLockScreen)
      UserDefaults.standard.removeObject(forKey: PassKeys.currentpass)
      UserDefaults.standard.removeObject(forKey: PassKeys.passTimeRequirement)
   }
   
}

struct SetPasswordView_Previews: PreviewProvider {
   static var previews: some View {
      NavigationStack {
         SetPasswordView(isLocked: .constant(false))
      }
   }
}
