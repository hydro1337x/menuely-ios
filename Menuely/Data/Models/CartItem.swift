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
    let price: Float
    let imageURL: String
    var quantity: Int = 1
    
    init(with product: Product) {
        id = product.id
        name = product.name
        price = product.price
        imageURL = product.image.url
    }
}
