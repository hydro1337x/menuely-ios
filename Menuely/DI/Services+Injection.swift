//
//  Services+Injection.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.07.2021..
//

import Resolver

extension Resolver: ResolverRegistering {
    public static func registerServices() {
        register { AppConfiguration() }.scope(.shared)
        register { Store<AppState>(AppState()) }.scope(.shared)
        register { AppEventsHandler() }.scope(.shared)
    }
}
