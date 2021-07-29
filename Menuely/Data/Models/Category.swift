//
//  Category.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 29.07.2021..
//

import Foundation

struct Category: Codable, Equatable, Identifiable {
    let id: Int
    let name: String
    let currency: String
    let restaurantId: Int
    let createdAt: TimeInterval
    let updatedAt: TimeInterval
    let image: RemoteImage
}
