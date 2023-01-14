//
//  UserDefaultHelper.swift
//  GithubAPI
//
//  Created by Bing Guo on 2023/1/11.
//

import Foundation

class UserDefaultHelper {
    enum Key: String {
        case followingUser = "following_user"
    }

    static func getObject<E: Codable>(key: Key, type: E.Type) -> E? {
        guard let data = UserDefaults.standard.value(forKey: key.rawValue) as? Data else { return nil }

        if let decoded = try? JSONDecoder().decode(type, from: data) {
            return decoded
        }
        return nil
    }

    static func saveObjects<E: Codable>(key: Key, objects: [E]) {
        if let encoded = try? JSONEncoder().encode(objects){
            UserDefaults.standard.set(encoded, forKey: key.rawValue)
        }
    }
}
