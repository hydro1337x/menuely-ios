//
//  CartItem.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 07.08.2021..
//

import Foundation

struct CartItem: Equatable, Identifiable {
    let id: Int
    let name: String
    let basePrice: Float
    var totalPrice: Float
    let currency: String
    let imageURL: String
    var quantity: Int = 1
    
    init(with product: Product) {
        id = product.id
        name = product.name
        basePrice = product.price
        totalPrice = basePrice
        currency = product.currency
        imageURL = product.image.url
    }
}
