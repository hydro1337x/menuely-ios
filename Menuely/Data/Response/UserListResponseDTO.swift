//
//  UserListResponseDTO.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.07.2021..
//

import Foundation

struct UserListResponseDTO: Decodable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case users = "data"
        case statusCode
    }
    
    let statusCode: Int
    var users: [User]
}
