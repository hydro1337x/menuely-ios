//
//  ViewModels+Injection.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.07.2021..
//

import Resolver

extension Resolver {
    public static func registerViewModels() {
        register { UsersListViewModel(users: .notRequested) }.scope(.shared)
        register { RootViewAppearance.ViewModel() }.scope(.shared)
    }
}
