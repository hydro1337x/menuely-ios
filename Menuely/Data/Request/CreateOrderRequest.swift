//
//  CreateOrderRequest.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 11.08.2021..
//

import Foundation

struct CreateOrderBodyRequest: BodyRequestable {
    let restaurantId: Int
    let tableId: Int
    let totalPrice: Float
    let orderedProducts: [OrderedProduct]
}

struct OrderedProduct: Encodable {
    let orderedProductId: Int
    let quantity: Int
    let price: Float
    
    init(with cartItem: CartItem) {
        orderedProductId = cartItem.id
        quantity = cartItem.quantity
        price = cartItem.basePrice
    }
}
