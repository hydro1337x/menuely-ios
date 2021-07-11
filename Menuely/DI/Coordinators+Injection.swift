//
//  Coordinators+Injection.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 11.07.2021..
//

import Resolver

extension Resolver {
    public static func registerCoordinators() {
        register { RootCoordinator() }.scope(.shared)
        register { AuthCoordinator() }.scope(.shared)
    }
}
