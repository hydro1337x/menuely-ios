//
//  SecureAppStorage.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 06.07.2021..
//

import Foundation

@propertyWrapper
struct SecureAppStorage {
    var item: KeychainItem
    init(_ account: String, service: String = Bundle.main.bundleIdentifier!) {
        self.item = .init(service: service, account: account)
    }
    public var wrappedValue: String? {
        get {
            item.get()
        }
        nonmutating set {
            item.set(newValue)
        }
    }
}
