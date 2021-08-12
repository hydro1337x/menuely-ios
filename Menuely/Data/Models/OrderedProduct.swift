//
//  OrderedProduct.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 12.08.2021..
//

import Foundation

struct OrderedProduct: Codable, Equatable {
    let orderedProductId: Int
    let quantity: Int
    let price: Decimal
    
    init(with cartItem: CartItem) {
        orderedProductId = cartItem.id
        quantity = cartItem.quantity
        price = Decimal(string: cartItem.basePrice.asTwoDecimalString)!
    }
}
