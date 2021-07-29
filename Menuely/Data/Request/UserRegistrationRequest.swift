//
//  UserRegistrationBodyRequest.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 07.07.2021..
//

import Foundation

struct UserRegistrationBodyRequest: BodyRequestable {
    let firstname: String
    let lastname: String
    let email: String
    let password: String
}
