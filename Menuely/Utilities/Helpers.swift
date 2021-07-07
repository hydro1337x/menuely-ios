//
//  Helpers.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.06.2021..
//

import Foundation
import Combine

extension Result {
    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
}

extension Encodable {
    func asJSON() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(self)
    }
}
