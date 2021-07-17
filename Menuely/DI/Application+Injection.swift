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
        register { Store<AppState>(AppState(coordinating: AppState.Coordinating(keychainRepository: resolve()))) }.scope(.application)
        register { ApplicationEventsHandler() }.scope(.application)
        registerViewModels()
        registerCoordinators()
        registerServices()
        registerRepositories()
        registerUtilities()
        registerConstants()
    }
}
