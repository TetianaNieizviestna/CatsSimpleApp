//
//  StorageHelper.swift
//  CatsSimpleApp
//

import Foundation

final class StorageHelper {
    static let shared = StorageHelper()

    enum Keys {
        static let sort = "CatsBreed.Sort"
    }

    func saveData<T: Codable>(key: String, object: T) {
        if let data = try? JSONEncoder().encode(object) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func getData<T: Codable>(for key: String, type: T.Type) -> T? {
        if let data = UserDefaults.standard.data(forKey: key) {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        return nil
    }
}
