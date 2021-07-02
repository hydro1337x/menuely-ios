//
//  Services+Injection.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.07.2021..
//

import Resolver

extension Resolver {
    // TODO: - Split registerServices into registerRepositories
    public static func registerServices() {
        register(name: .baseURL) { "https://menuely.herokuapp.com" }
        register { UsersRemoteRepository(session: resolve(ApplicationConfiguration.self).configuredURLSesssion, baseURL: resolve(name: .baseURL)) as UsersRemoteRepositing }
        register { UsersService() as UsersServicing }
    }
}

extension Resolver.Name {
    static let baseURL = Self("baseURL")
}
