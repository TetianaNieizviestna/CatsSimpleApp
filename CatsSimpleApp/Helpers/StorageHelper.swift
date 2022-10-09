//
//  CacheHelper.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import UIKit

class StorageHelper {
    static let shared: StorageHelper = StorageHelper()
    
    enum Keys {
        static let sort = "Launch.Sort"
    }
    
    func saveData<T: Codable>(key: String, object: T) {
        if let data = try? JSONEncoder().encode(object) {
            UserDefaults.standard.set(data, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }

    func getData<T: Codable>(for key: String, type: T.Type) -> T? {
        if let data = UserDefaults.standard.data(forKey: key) {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        return nil
    }
}
