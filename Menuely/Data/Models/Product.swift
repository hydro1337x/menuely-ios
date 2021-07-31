//
//  Product.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.07.2021..
//

import Foundation

struct Product: Codable, Equatable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let price: Float
    let currency: String
    let restaurantId: Int
    let categoryId: Int
    let createdAt: TimeInterval
    let updatedAt: TimeInterval
    let image: RemoteImage
}
