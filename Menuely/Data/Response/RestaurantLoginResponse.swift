//
//  RestaurantLoginResponse.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 12.07.2021..
//

import Foundation

struct RestaurantLoginResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case authenticatedRestaurant = "data"
        case statusCode
    }
    
    let statusCode: Int
    let authenticatedRestaurant: AuthenticatedRestaurant
}
