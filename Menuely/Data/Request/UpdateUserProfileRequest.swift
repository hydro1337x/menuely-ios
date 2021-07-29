//
//  UpdateUserProfileBodyRequest.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 23.07.2021..
//

import Foundation

struct UpdateUserProfileBodyRequest: BodyRequestable {
    let firstname: String
    let lastname: String
}
