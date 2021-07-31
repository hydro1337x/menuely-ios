//
//  Application+Injection.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.07.2021..
//

import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { Store<AppState>(AppState()) }.scope(.application)
        register { ApplicationEventsHandler() }.scope(.application)
        registerViewModels()
        registerServices()
        registerRepositories()
        registerUtilities()
        registerConstants()
    }
}
