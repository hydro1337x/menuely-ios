//
//  RestaurantResponseDTO.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 22.07.2021..
//

import Foundation

struct RestaurantResponseDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case restaurant = "data"
        case statusCode
    }
    
    let statusCode: Int
    let restaurant: Restaurant
}
