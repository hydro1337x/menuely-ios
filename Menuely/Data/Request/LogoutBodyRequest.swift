//
//  LogoutBodyRequest.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.07.2021..
//

import Foundation

struct LogoutBodyRequest: BodyRequestable {
    let refreshToken: String
}
