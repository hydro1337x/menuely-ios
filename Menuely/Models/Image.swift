//
//  Image.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.07.2021..
//

import Foundation

struct Image: Codable, Equatable {
    let id: Int
    let name: String
    let url: String
    let createdAt: TimeInterval
    let updatedAt: TimeInterval
}
