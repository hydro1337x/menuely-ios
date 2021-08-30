//
//  AuthenticatedUser.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 08.07.2021..
//

import Foundation

struct AuthenticatedUser: Codable, Equatable {
    let user: User
    var auth: Tokens
}

