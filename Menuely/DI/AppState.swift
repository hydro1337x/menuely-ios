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
    }
}

extension AppState {
    /*
     AppState.Routing should contain data which is needed to transition from one screen to another
     It is used inside actions
     */
    struct Routing: Equatable {
        
        var tab: TabBarView.Routing = .scan
        var root: RootView.Routing = .auth
        var authSelection: AuthSelectionView.Routing = AuthSelectionView.Routing(selectedAuth: .login)
        var profile: ProfileView.Routing = ProfileView.Routing()
        var options: OptionsView.Routing = OptionsView.Routing()
        var info: InfoView.Routing = InfoView.Routing()
        var activityIndicator: ActivityIndicatorView.Routing = ActivityIndicatorView.Routing()
        var alert: AlertView.Routing = AlertView.Routing()
    }
}

extension AppState {
    struct Application: Equatable {
        var isActive: Bool = false
        var keyboardHeight: CGFloat = 0
    }
}

//func == (lhs: AppState, rhs: AppState) -> Bool {
//    return lhs.data == rhs.data &&
//           lhs.routing == rhs.coordinating &&
//           lhs.application == rhs.application
//}
