//
//  Repositories+Injection.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 02.07.2021..
//

import Foundation
import Resolver
import Alamofire

extension Resolver {
    public static func registerRepositories() {
        register { UsersRemoteRepository() as UsersRemoteRepositing }
        register { Authenticator(session: AF) as Authenticating }
        register { AuthRemoteRepository() as AuthRemoteRepositing }
        register { KeychainRepository() as KeychainRepositing }
    }
}
