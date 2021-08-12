//
//  Order.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 12.08.2021..
//

import Foundation

struct Order: Codable, Equatable, Identifiable {
    let id: Int
    let totalPrice: Float
    let currency: String
    let tableId: Int
    let createdAt: TimeInterval
    let updatedAt: TimeInterval
    let orderedProducts: [OrderedProduct]
    
    // Employee
    let customerName: String?
    
    // User
    let employerName: String?
    let employeeName: String?
}
