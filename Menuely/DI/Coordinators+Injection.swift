//
//  Coordinators+Injection.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 11.07.2021..
//

import Resolver

extension Resolver {
    public static func registerCoordinators() {
        register { RootCoordinator(appState: resolve()) }.scope(.shared)
        register { TabCoordinator() }.scope(.shared)
        register { AuthCoordinator(appState: resolve()) }.scope(.shared)
        register { RegistrationCoordinator(appState: resolve()) }.scope(.shared)
        register { LoginCoordinator(appState: resolve()) }.scope(.shared)
        
    }
}
