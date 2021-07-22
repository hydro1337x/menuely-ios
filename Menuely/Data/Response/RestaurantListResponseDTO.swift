//
//  RestaurantListResponseDTO.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 22.07.2021..
//

import Foundation

struct RestaurantListResponseDTO: Decodable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case restaurants = "data"
        case statusCode
    }
    
    let statusCode: Int
    var restaurants: [Restaurant]
}
