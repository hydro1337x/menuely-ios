//
//  UserLoginRequestDTO.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 07.07.2021..
//

import Foundation

struct UserLoginRequestDTO: Codable {
    let email: String
    let password: String
}
