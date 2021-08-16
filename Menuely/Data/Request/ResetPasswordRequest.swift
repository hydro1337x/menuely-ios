//
//  ResetPasswordRequest.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 16.08.2021..
//

import Foundation

struct ResetPasswordBodyRequest: BodyRequestable {
    let email: String
}
