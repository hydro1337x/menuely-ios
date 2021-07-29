//
//  LoginBodyRequest.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 07.07.2021..
//

import Foundation

struct LoginBodyRequest: BodyRequestable {
    let email: String
    let password: String
}
