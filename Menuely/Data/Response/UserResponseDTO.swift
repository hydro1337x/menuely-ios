//
//  UserResponseDTO.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 22.07.2021..
//

import Foundation

struct UserResponseDTO: Codable {
    let statusCode: Int
    let data: User
}
