//
//  Services+Injection.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.07.2021..
//

import Resolver

extension Resolver {
    public static func registerServices() {
        register(name: .baseURL) { "https://menuely.herokuapp.com" }
        register { UsersService() as UsersServicing }
    }
}

extension Resolver.Name {
    static let baseURL = Self("baseURL")
}
