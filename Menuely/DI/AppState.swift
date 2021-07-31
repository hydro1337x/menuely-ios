//
//  AppState.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.06.2021..
//

import SwiftUI
import Resolver

struct AppState: Equatable {
    var data: Data = Data()
    var routing: Routing = Routing()
    var application: Application = Application()
    
    mutating func reset() {
        self.data = Data()
        self.routing = Routing()
        self.application = Application()
    }
}

extension AppState {
    /* AppState.Data should contain data which is shared across the whole application, since AppState is always wrapped with the Store typealias which on its own is a CurrentValueSubject, it will emit all changes if a property is mutated and all views which use that data can stay in sync
     */
    struct Data: Equatable {
        var selectedEntity: EntityType = .user
        var authenticatedUser: AuthenticatedUser?
        var authenticatedRestaurant: AuthenticatedRestaurant?
        
        var updateUserProfileView: Bool = false
        var updateRestaurantProfileView: Bool = false
        
        var updateMenusListView: Bool = false
        
        var updateCategoriesListView: Bool = false
        
        var updateProductsListView: Bool = false
        
        var searchList: SearchListView.Search = SearchListView.Search()
    }
}

extension AppState {
    /*
     AppState.Routing should contain data which is needed to transition from one screen to another
     It is used inside actions
     */
    struct Routing: Equatable {
        
        var tab: TabBarView.Routing = .search
        var root: RootView.Routing = .auth
        var authSelection: AuthSelectionView.Routing = AuthSelectionView.Routing(selectedAuth: .login)
        var profile: ProfileView.Routing = ProfileView.Routing()
        var options: OptionsView.Routing = OptionsView.Routing()
        var info: InfoView.Routing = InfoView.Routing()
        var activityIndicator: ActivityIndicatorView.Routing = ActivityIndicatorView.Routing()
        var alert: AlertView.Routing = AlertView.Routing()
        var action: ActionView.Routing = ActionView.Routing()
        var menusList: MenusListView.Routing = MenusListView.Routing()
        var categoriesList: CategoriesListView.Routing = CategoriesListView.Routing()
        var createCategory: CreateCategoryView.Routing = CreateCategoryView.Routing()
        var updateCategory: UpdateCategoryView.Routing = UpdateCategoryView.Routing()
        var productsList: ProductsListView.Routing = ProductsListView.Routing()
        var createProduct: CreateProductView.Routing = CreateProductView.Routing()
        var updateProduct: UpdateProductView.Routing = UpdateProductView.Routing()
        var searchList: SearchListView.Routing = SearchListView.Routing()
    }
}

extension AppState {
    struct Application: Equatable {
        var isActive: Bool = true
        var keyboardHeight: CGFloat = 0
    }
}

//func == (lhs: AppState, rhs: AppState) -> Bool {
//    return lhs.data == rhs.data &&
//           lhs.routing == rhs.coordinating &&
//           lhs.application == rhs.application
//}
