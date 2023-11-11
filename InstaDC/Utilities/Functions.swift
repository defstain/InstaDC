//
//  Functions.swift
//  InstaDC
//
//  Created by IC Deis on 6/24/23.
//

import SwiftUI

/// Clears all saved values from UserDefaults
func clearUserDefualts() {
   DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      UserDefaults.standard.dictionaryRepresentation().forEach { key, _ in
         UserDefaults.standard.removeObject(forKey: key)
      }
   }
}


/// Generic function to save data to UserDefaults
func saveToUserDefaults<T: Codable>(data: T, key: String) {
   let encoder = JSONEncoder()
   if let data = try? encoder.encode(data) {
      UserDefaults.standard.set(data, forKey: "dbuser")
   }
}

/// Genereic function to get data from UserDefaults
func getFromUserDefaults<T: Codable>(as type: T.Type, key: String) -> T? {
   guard let udData = UserDefaults.standard.data(forKey: key) else { return nil }
   guard let decoded = try? JSONDecoder().decode(T.self, from: udData) else { return nil }
   return decoded
}

/// Saves the image to UserDefaults
func saveImageToUserDefaults(image: UIImage, key: String) {
   guard let data = image.jpegData(compressionQuality: 0.5) else { return }
   let encoded = try! PropertyListEncoder().encode(data)
   UserDefaults.standard.set(encoded, forKey: key)
}

/// Gets the image from UserDefaults
func getImageFromUserDefaults(key: String) -> UIImage? {
   guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
   let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
   return UIImage(data: decoded)
   
}

/// Validation
func userValidate(Input:String) -> Bool {
   return Input.range(of: "\\A\\w{7,18}\\z", options: .regularExpression) != nil
}
//('/^[A-Za-z0-9_]+$/', $username)
