//
//  UpdateMenuRequestDTO.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 26.07.2021..
//

import Foundation

struct UpdateMenuRequestDTO: Encodable {
    let name: String?
    let description: String?
    let currency: String?
}
