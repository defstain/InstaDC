//
//  ChangeAppLocaleView.swift
//  InstaDC
//
//  Created by IC Deis on 7/6/23.
//

import SwiftUI

struct ChangeAppLocaleView: View {
   @Environment(\.dismiss) private var dismiss
   @AppStorage("app_locale") var appLocale: String?
   @State var locale: AppLocale
   
   var body: some View {
      List {
         ForEach(AppLocale.allCases, id: \.self) { lang in
            HStack {
               Text(lang.description)
               Spacer()
               if locale == lang {
                  Image(systemName: "checkmark")
                     .foregroundColor(.blue)
               }
            }
            .background(.white.opacity(0.00001))
            .onTapGesture {
               locale = lang
            }
         }
      }
      .navigationTitle(SettingLocale.app_language)
      .toolbar {
         ToolbarItem(placement: .navigationBarTrailing) {
            Button(ActionLocale.save) {
               UserDefaults.standard.setValue(locale.rawValue, forKey: "app_locale")
               dismiss()
            }
            .foregroundColor(.blue)
         }

      }
//      .onAppear {
//         if let lang = appLocale {
//            if lang == "en" { locale = .en }
//            if lang == "uz" { locale = .uz }
//         }
//      }
   }
}

struct ChangeAppLocaleView_Previews: PreviewProvider {
   static var previews: some View {
      NavigationStack {
         ChangeAppLocaleView(locale: .en)
      }
   }
}
