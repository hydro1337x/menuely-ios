//
//  OrdersListResponse.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 12.08.2021..
//

import Foundation

struct OrdersListResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case orders = "data"
        case statusCode
    }
    
    let statusCode: Int
    let orders: [Order]
}
