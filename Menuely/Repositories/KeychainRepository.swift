//
//  KeychainRepository.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 17.07.2021..
//

import Foundation

enum KeychainAccount: String {
    case tokens
}

protocol KeychainRepositing {
    func loadData<T: Codable>(for account: KeychainAccount) -> T?
    func saveData<T: Codable>(_ data: T?, to account: KeychainAccount)
    func removeData(for account: KeychainAccount)
}

class KeychainRepository: KeychainRepositing {
    
    var encoder = JSONEncoder()
    var decoder = JSONDecoder()
    
    init() {}
    
    func loadData<T>(for account: KeychainAccount) -> T? where T: Codable {
        let item = KeychainItem(service: Bundle.main.bundleIdentifier!, account: account.rawValue)
        return item.get()
                    .flatMap { Data(base64Encoded: $0) }
                    .flatMap { try? decoder.decode(T.self, from: $0) }
    }
    
    func saveData<T>(_ data: T?, to account: KeychainAccount) where T: Codable {
        let item = KeychainItem(service: Bundle.main.bundleIdentifier!, account: account.rawValue)
        let encoded = data
            .flatMap { try? encoder.encode($0) }
            .flatMap { $0.base64EncodedString() }
        item.set(encoded)
    }
    
    func removeData(for account: KeychainAccount) {
        let item = KeychainItem(service: Bundle.main.bundleIdentifier!, account: account.rawValue)
        item.delete()
    }
}
