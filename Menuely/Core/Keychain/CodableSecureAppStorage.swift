//
//  CodableSecureAppStorage.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 06.07.2021..
//

import Foundation

@propertyWrapper
struct CodableSecureAppStorage<C: Codable> {

    var item: KeychainItem
    var encoder = JSONEncoder()
    var decoder = JSONDecoder()

    init(_ account: String, service: String = Bundle.main.bundleIdentifier!) {
        self.item = .init(service: service, account: account)
    }

    public var wrappedValue: C? {
        get {
            item.get()
                .flatMap { Data(base64Encoded: $0) }
                .flatMap { try? decoder.decode(C.self, from: $0) }
        }
        nonmutating set {
            let string = newValue
                .flatMap { try? encoder.encode($0) }
                .flatMap { $0.base64EncodedString() }
            item.set(string)
        }
    }
}
