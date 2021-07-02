//
//  Application+Injection.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.07.2021..
//

import Resolver

typealias InjectedObservedObject = InjectedObject
typealias InjectedEnvironmentObject = InjectedObject

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { ApplicationConfiguration() }.scope(.shared)
        register { Store<AppState>(AppState()) }.scope(.shared)
        register { ApplicationEventsHandler() }.scope(.shared)
        registerServices()
        registerViewModels()
    }
}
