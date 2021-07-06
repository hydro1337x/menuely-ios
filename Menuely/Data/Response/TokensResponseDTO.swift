//
//  TokensResponseDTO.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 03.07.2021..
//

import Foundation

struct TokensResponseDTO: Codable {
    let accessToken: String
    let refreshToken: String
}
