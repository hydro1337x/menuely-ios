//
//  RestaurantResponseDTO.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 22.07.2021..
//

import Foundation

struct RestaurantResponseDTO: Codable {
    let statusCode: Int
    let data: Restaurant
}
