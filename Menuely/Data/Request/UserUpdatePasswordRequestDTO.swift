//
//  UserUpdatePasswordRequestDTO.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 24.07.2021..
//

import Foundation

struct UpdatePasswordRequestDTO: Encodable {
    let oldPassword: String
    let newPassword: String
    let repeatedNewPassword: String
}
