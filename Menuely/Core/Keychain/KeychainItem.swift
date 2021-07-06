//
//  KeychainItem.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 06.07.2021..
//

import Foundation

struct KeychainItem {

    // MARK: Types
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError(status: OSStatus)
    }

    // MARK: Stored Properties
    let service: String
    let account: String
    let accessGroup: String?

    // MARK: Initialization
    init(service: String, account: String, accessGroup: String? = nil) {
        self.service = service
        self.account = account
        self.accessGroup = accessGroup
    }

    // MARK: Methods
    func get() -> String? {
        /*
         Build a query to find the item that matches the service, account and
         access group.
         */
        var query = KeychainItem.query(service: service, account: account, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue

        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { return nil }
        guard status == noErr else { return nil }

        // Parse the password string from the query result.
        guard let existingItem = queryResult as? [String: AnyObject],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8)
            else {
                return nil
        }

        return password
    }

    func set(_ value: String?) {
        if let value = value {
            save(value)
        } else {
            delete()
        }
    }

    func save(_ password: String) {
        // Encode the password into an Data object.
        let encodedPassword = Data(password.utf8)

        if get() != nil {
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?

            let query = KeychainItem.query(service: service,
                                           account: account,
                                           accessGroup: accessGroup)
            _ = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        } else {
            var newItem = KeychainItem.query(service: service,
                                             account: account,
                                             accessGroup: accessGroup)

            newItem[kSecValueData as String] = encodedPassword as AnyObject?

            _ = SecItemAdd(newItem as CFDictionary, nil)
        }
    }

    func delete() {
        // Delete the existing item from the keychain.
        let query = KeychainItem.query(service: service, account: account, accessGroup: accessGroup)

        _ = SecItemDelete(query as CFDictionary)
    }

    // MARK: Helpers
    private static func items(forService service: String, accessGroup: String? = nil) throws -> [KeychainItem] {
        // Build a query for all items that match the service and access group.
        var query = KeychainItem.query(service: service, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanFalse

        // Fetch matching items from the keychain.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        // If no items were found, return an empty array.
        guard status != errSecItemNotFound else { return [] }

        // Throw an error if an unexpected status was returned.
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }

        // Cast the query result to an array of dictionaries.
        guard let resultData = queryResult as? [[String: AnyObject]] else { throw KeychainError.unexpectedItemData }

        // Create a `KeychainItem` for each dictionary in the query result.
        var items = [KeychainItem]()
        for result in resultData {
            guard let account = result[kSecAttrAccount as String] as? String else {
                continue
            }

            let item = KeychainItem(service: service, account: account, accessGroup: accessGroup)
            items.append(item)
        }

        return items
    }

    private static func query(service: String,
                              account: String? = nil,
                              accessGroup: String? = nil) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?

        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }

        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }

        return query
    }

}
