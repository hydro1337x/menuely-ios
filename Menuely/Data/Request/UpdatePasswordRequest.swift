//
//  UpdatePasswordBodyRequest.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 24.07.2021..
//

import Foundation

struct UpdatePasswordBodyRequest: BodyRequestable {
    let oldPassword: String
    let newPassword: String
    let repeatedNewPassword: String
}
