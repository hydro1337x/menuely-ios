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
        register { EditUserProfileViewModel(appState: resolve()) }.scope(.shared)
        register { EditRestaurantProfileViewModel(appState: resolve()) }.scope(.shared)
        register { InfoView.ViewModel(appState: resolve()) }.scope(.shared)
        register { ActivityIndicatorView.ViewModel(appState: resolve()) }.scope(.shared)
        register { AlertView.ViewModel(appState: resolve()) }.scope(.shared)
        register { ActionView.ViewModel(appState: resolve()) }.scope(.shared)
        register { UpdatePasswordViewModel(appState: resolve()) }.scope(.shared)
        register { UpdateEmailViewModel(appState: resolve()) }.scope(.shared)
        register { ScanViewModel() }.scope(.shared)
        register { MenusListViewModel(appState: resolve()) }.scope(.shared)
        register { CreateMenuViewModel(appState: resolve()) }.scope(.shared)
        register { UpdateMenuViewModel(appState: resolve()) }.scope(.shared)
        register { CategoriesListViewModel(appState: resolve()) }
        register { CreateCategoryViewModel(appState: resolve()) }
        register { UpdateCategoryViewModel(appState: resolve()) }
        register { ProductsListView.ViewModel(appState: resolve()) }
        register { CreateProductView.ViewModel(appState: resolve()) }
        register { UpdateProductView.ViewModel(appState: resolve()) }
    }
}
