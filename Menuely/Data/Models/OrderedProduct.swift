//
//  OrderedProduct.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 13.08.2021..
//

import Foundation

struct OrderedProduct: Codable, Equatable, Identifiable {
    let id: Int
    let name: String
    let orderedProductId: Int
    let price: Float
    let description: String
    let imageUrl: String
    let quantity: Int
    let createdAt: TimeInterval
    let updatedAt: TimeInterval
}
