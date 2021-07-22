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
        register { LoginViewModel(appState: resolve()) }.scope(.shared)
        register { ProfileViewModel(appState: resolve()) }.scope(.shared)
        register { UserProfileViewModel(appState: resolve()) }.scope(.shared)
        register { RestaurantProfileViewModel(appState: resolve()) }.scope(.shared)
        register { OptionsViewModel(appState: resolve()) }.scope(.shared)
        register { TabBarViewModel(appState: resolve()) }.scope(.shared)
        register { RootViewModel(authService: resolve(), appState: resolve()) }.scope(.shared)
        register { AuthSelectionViewModel(appState: resolve()) }.scope(.shared)
    }
}
