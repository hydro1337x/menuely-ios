//
//  AuthenticatedRestaurant.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 12.07.2021..
//

import Foundation

struct AuthenticatedRestaurant: Codable, Equatable {
    let restaurant: Restaurant
    var auth: Tokens
}
