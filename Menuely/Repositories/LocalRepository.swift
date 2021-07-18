//
//  LocalRepository.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 17.07.2021..
//

import Foundation

enum StorageKey: String {
    case user
    case restaurant
}

protocol LocalRepositing {
    func load<T: Codable>(_ type: T.Type, for key: StorageKey) -> T?
    func save<T: Codable>(_ value: T?, for key: StorageKey)
    func removeValue(for key: StorageKey)
}

class LocalRepository: LocalRepositing {
    
    private var userDefaults = UserDefaults.standard
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    
    func load<T: Codable>(_ type: T.Type, for key: StorageKey) -> T? {
        guard let loaded = userDefaults.object(forKey: key.rawValue) as? Data else { return nil }
        
        return try? decoder.decode(T.self, from: loaded)
    }
    
    func save<T: Codable>(_ value: T?, for key: StorageKey) {
        let encoded = try? encoder.encode(value)
           
        userDefaults.setValue(encoded, forKey: key.rawValue)
    }
    
    func removeValue(for key: StorageKey) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
    
}
