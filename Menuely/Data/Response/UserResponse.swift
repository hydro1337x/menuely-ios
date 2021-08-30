//
//  UserResponse.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 22.07.2021..
//

import Foundation

struct UserResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case user = "data"
        case statusCode
    }
    
    let statusCode: Int
    let user: User
}
