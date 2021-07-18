//
//  SecureLocalRepository.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 17.07.2021..
//

import Foundation

enum SecureStorageKey: String {
    case authenticatedUser
    case authenticatedRestaurant
}

protocol SecureLocalRepositing {
    func load<T: Codable>(_ type: T.Type, for key: SecureStorageKey) -> T?
    func save<T: Codable>(_ value: T?, for key: SecureStorageKey)
    func removeValue(for key: SecureStorageKey)
}

class SecureLocalRepository: SecureLocalRepositing {
    
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    
    func load<T: Codable>(_ type: T.Type, for key: SecureStorageKey) -> T? {
        let item = KeychainItem(service: Bundle.main.bundleIdentifier!, account: key.rawValue)
        return item.get()
                    .flatMap { Data(base64Encoded: $0) }
                    .flatMap { try? decoder.decode(T.self, from: $0) }
    }
    
    func save<T: Codable>(_ value: T?, for key: SecureStorageKey) {
        let item = KeychainItem(service: Bundle.main.bundleIdentifier!, account: key.rawValue)
        let encoded = value
            .flatMap { try? encoder.encode($0) }
            .flatMap { $0.base64EncodedString() }
        item.set(encoded)
    }
    
    func removeValue(for key: SecureStorageKey) {
        let item = KeychainItem(service: Bundle.main.bundleIdentifier!, account: key.rawValue)
        item.delete()
    }
}
