//
//  User.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 06.07.2021..
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    let id: Int
    let email: String
    let firstname: String
    let lastname: String
    let createdAt: TimeInterval
    let updatedAt: TimeInterval
    let profileImage: RemoteImage?
    let coverImage: RemoteImage?
}
