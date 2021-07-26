//
//  RestaurantLoginResponseDTO.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 12.07.2021..
//

import Foundation

struct RestaurantLoginResponseDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case authenticatedRestaurant = "data"
        case statusCode
    }
    
    let statusCode: Int
    let authenticatedRestaurant: AuthenticatedRestaurant
}
