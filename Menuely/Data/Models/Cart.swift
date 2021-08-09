//
//  Cart.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 07.08.2021..
//

import Foundation

struct Cart: Equatable {
    let restaurantId: Int
    let tableId: Int
    var totalPrice: Float {
        return cartItems.reduce(0) { result, cartItem in
            return result + cartItem.totalPrice
        }
    }
    var cartItems: [CartItem] = []
}
