//
//  RestaurantLoginRequestDTO.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 12.07.2021..
//

import Foundation

struct RestaurantLoginRequestDTO: Codable {
    let email: String
    let password: String
}
