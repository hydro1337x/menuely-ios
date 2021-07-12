//
//  RestaurantLoginResponseDTO.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 12.07.2021..
//

import Foundation

struct RestaurantLoginResponseDTO: Decodable {
    let statusCode: Int
    let data: RestaurantAuth
}
