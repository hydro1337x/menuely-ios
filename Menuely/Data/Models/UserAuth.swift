//
//  UserAuth.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 08.07.2021..
//

import Foundation

struct UserAuth: Decodable {
    let user: User
    let auth: Tokens
}
