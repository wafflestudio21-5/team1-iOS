//
//  UserDefaultsRepository.swift
//  Watomate
//
//  Created by 이지현 on 1/10/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import Foundation

protocol UserDefaultsRepositoryProtocol {
    func get<T: Codable>(_ type: T.Type, key: UserDefaultsKey) -> T?
    func set<T: Codable>(_ type: T.Type, key: UserDefaultsKey, value: T?)
    func removeAll()
}

enum UserDefaultsKey: String {
    case isLoggedIn
    case loginMethod
    case accessToken
    case userId
    case username
    case intro
    case profilePic
    case followerCount
    case followingCount
}

class UserDefaultsRepository: UserDefaultsRepositoryProtocol {
    private let storage = UserDefaults.standard
    
    func get<T: Codable>(_ type: T.Type, key: UserDefaultsKey) -> T?{
        guard let data = storage.object(forKey: key.rawValue) as? Data else { return nil }
        return try? JSONDecoder().decode(type.self, from: data)
    }
    
    func set<T: Codable>(_ type: T.Type, key: UserDefaultsKey, value: T?) {
        let data = try? JSONEncoder().encode(value)
        storage.set(data, forKey: key.rawValue)
    }
    
    func removeAll() {
        for key in storage.dictionaryRepresentation().keys {
            storage.removeObject(forKey: key.description)
        }
    }
    
}
