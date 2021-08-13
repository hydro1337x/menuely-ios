//
//  OrderResponse.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 13.08.2021..
//

import Foundation

struct OrderResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case order = "data"
        case statusCode
    }
    
    let statusCode: Int
    let order: Order
}
