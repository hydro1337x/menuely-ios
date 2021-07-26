//
//  CreateMenuRequestDTO.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 26.07.2021..
//

import Foundation

struct CreateMenuRequestDTO: Encodable {
    let name: String
    let description: String
    let currency: String
    let numberOfTables: Int
}
