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
    let totalPrice: Decimal
    let orderedProducts: [OrderedProduct]
    
    init(restaurantId: Int, tableId: Int, totalPrice: Float, orderedProducts: [OrderedProduct]) {
        self.restaurantId = restaurantId
        self.tableId = tableId
        self.totalPrice = Decimal(string: format(price: totalPrice))!
        self.orderedProducts = orderedProducts
    }
}

struct OrderedProduct: Encodable {
    let orderedProductId: Int
    let quantity: Int
    let price: Decimal
    
    init(with cartItem: CartItem) {
        orderedProductId = cartItem.id
        quantity = cartItem.quantity
        price = Decimal(string: format(price: cartItem.basePrice))!
    }
}

fileprivate func format(price: Float) -> String {
    return String(format: "%.2f", price)
}
