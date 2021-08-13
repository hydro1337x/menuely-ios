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
    let orderedProducts: [PreparedProduct]
    
    init(restaurantId: Int, tableId: Int, totalPrice: Float, orderedProducts: [PreparedProduct]) {
        self.restaurantId = restaurantId
        self.tableId = tableId
        self.totalPrice = Decimal(string: totalPrice.asTwoDecimalString)!
        self.orderedProducts = orderedProducts
    }
}
