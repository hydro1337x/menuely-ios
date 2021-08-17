//
//  Invitation.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.08.2021..
//

import Foundation

struct Invitation: Codable, Equatable, Identifiable {
    let id: Int
    let employee: User
    let employer: Restaurant
}
