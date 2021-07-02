//
//  User.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.07.2021..
//

import Foundation

struct Users: Codable, Equatable {
    let statusCode: Int
    var data: [User]
}

struct User: Codable, Identifiable, Equatable {
    let id: Int
    let email: String
    let firstname: String
    let lastname: String
    let createdAt: TimeInterval
    let updatedAt: TimeInterval
    let profileImage: Image?
    let coverImage: Image?
}
