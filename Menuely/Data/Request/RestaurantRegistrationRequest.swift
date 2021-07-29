//
//  RestaurantRegistrationBodyRequest.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 12.07.2021..
//

import Foundation

struct RestaurantRegistrationBodyRequest: BodyRequestable {
    let email: String
    let password: String
    let description: String
    let name: String
    let country: String
    let city: String
    let address: String
    let postalCode: String
}
