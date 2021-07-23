//
//  RestaurantUpdateProfileRequestDTO.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 23.07.2021..
//

import Foundation

struct RestaurantUpdateProfileRequestDTO: Encodable {
    let name: String
    let description: String
    let country: String
    let city: String
    let address: String
    let postalCode: String
}
