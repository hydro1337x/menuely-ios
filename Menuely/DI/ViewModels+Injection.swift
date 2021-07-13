//
//  ViewModels+Injection.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.07.2021..
//

import Resolver

extension Resolver {
    public static func registerViewModels() {
        register { RootViewAppearance.ViewModel() }.scope(.shared)
        register { UserRegistrationViewModel() }.scope(.shared)
        register { RestaurantRegistrationViewModel() }.scope(.shared)
        register { LoginViewModel() }.scope(.shared)
    }
}
