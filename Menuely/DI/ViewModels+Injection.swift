//
//  ViewModels+Injection.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.07.2021..
//

import Resolver

extension Resolver {
    public static func registerViewModels() {
        register { RootViewAppearance.ViewModel() }
        register { UserRegistrationViewModel() }
        register { RestaurantRegistrationViewModel() }
        register { LoginViewModel(appState: resolve()) }
        
        register { ProfileViewModel(appState: resolve()) }
        register { UserProfileViewModel(appState: resolve()) }
        register { RestaurantProfileViewModel(appState: resolve()) }
        
        register { OptionsViewModel(appState: resolve()) }
        register { TabBarViewModel(appState: resolve()) }
        register { RootViewModel(authService: resolve(), appState: resolve()) }
        register { AuthSelectionViewModel(appState: resolve()) }
        register { EditUserProfileViewModel(appState: resolve()) }
        register { EditRestaurantProfileViewModel(appState: resolve()) }
        
        register { InfoView.ViewModel(appState: resolve()) }
        register { ActivityIndicatorView.ViewModel(appState: resolve()) }
        register { AlertView.ViewModel(appState: resolve()) }
        register { ActionView.ViewModel(appState: resolve()) }
        
        register { UpdatePasswordViewModel(appState: resolve()) }
        register { UpdateEmailViewModel(appState: resolve()) }
        
        register { ScanViewModel() }.scope(.shared)
        
        register { MenusListViewModel(appState: resolve()) }
        register { CreateMenuViewModel(appState: resolve()) }
        register { UpdateMenuViewModel(appState: resolve()) }
        
        register { CategoriesListViewModel(appState: resolve()) }
        register { CreateCategoryViewModel(appState: resolve()) }
        register { UpdateCategoryViewModel(appState: resolve()) }
        
        register { ProductsListView.ViewModel(appState: resolve()) }
        register { CreateProductView.ViewModel(appState: resolve()) }
        register { UpdateProductView.ViewModel(appState: resolve()) }
        
        register { SearchListView.ViewModel(appState: resolve()) }
        register { UsersSearchListView.ViewModel(appState: resolve()) }
        register { RestaurantsSearchListView.ViewModel(appState: resolve()) }
    }
}
