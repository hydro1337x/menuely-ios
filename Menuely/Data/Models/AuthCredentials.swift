//
//  AuthCredentials.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 15.07.2021..
//

import Foundation
import Alamofire

struct AuthCredentials: AuthenticationCredential {
    var requiresRefresh: Bool
}
