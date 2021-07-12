//
//  RestaurantAuth.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 12.07.2021..
//

import Foundation

struct RestaurantAuth: Decodable {
    let restaurant: Restaurant
    let auth: Tokens
}
