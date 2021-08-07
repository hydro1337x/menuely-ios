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
    var totalPrice: Float = 0
    var cartItems: [CartItem] = []
}
