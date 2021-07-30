//
//  ProductsListResponse.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.07.2021..
//

import Foundation

struct ProductsListResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case products = "data"
        case statusCode
    }
    
    let statusCode: Int
    let products: [Product]
}
