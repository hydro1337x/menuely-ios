//
//  User.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.07.2021..
//

import Foundation

struct User: Codable, Equatable {
    let id: Int
    let email: String
    let firstname: String
    let lastname: String
    let createdAt: TimeInterval
    let updatedAt: TimeInterval
    let profileImage: Image
    let coverImage: Image
}
