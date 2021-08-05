//
//  Restaurant.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 12.07.2021..
//

import Foundation

struct Restaurant: Codable, Equatable, Identifiable {
    let id: Int
    let email: String
    let name: String
    let description: String
    let country: String
    let city: String
    let address: String
    let postalCode: String
    let activeMenuId: Int?
    let createdAt: TimeInterval
    let updatedAt: TimeInterval
//    let employees: [User]=
    let profileImage: RemoteImage?
    let coverImage: RemoteImage?
}
