//
//  Repositories+Injection.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 02.07.2021..
//

import Foundation
import Resolver

extension Resolver {
    public static func registerRepositories() {
        register { UsersRemoteRepository() as UsersRemoteRepositing }
    }
}
