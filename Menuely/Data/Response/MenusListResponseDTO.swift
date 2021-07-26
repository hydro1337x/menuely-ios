//
//  MenusListResponseDTO.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 26.07.2021..
//

import Foundation

struct MenusListResponseDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case menus = "data"
        case statusCode
    }
    
    let statusCode: Int
    let menus: [Menu]
}
