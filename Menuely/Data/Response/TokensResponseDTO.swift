//
//  TokensResponseDTO.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 03.07.2021..
//

import Foundation

struct TokensResponseDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case tokens = "data"
        case statusCode
    }
    
    let statusCode: Int
    var tokens: Tokens
}
