//
//  Menu.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 26.07.2021..
//

import Foundation

struct Menu: Codable, Equatable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let currency: String
    let restaurantId: Int
    let createdAt: TimeInterval
    let updatedAt: TimeInterval
}
