//
//  AppState.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.06.2021..
//

import SwiftUI
import Combine

struct AppState: Equatable {
    var data = Data()
    var coordinating = Coordinating()
    var application = Application()
}

extension AppState {
    /* AppState.Data should contain data which is shared across the whole application, since AppState is always wrapped with the Store typealias which on its own is a CurrentValueSubject, it will emit all changes if a property is mutated and all views which use that data can stay in sync
     */
    struct Data: Equatable {
        var tokens: Tokens?
        var selectedEntity: EntityType = .user
    }
}

extension AppState {
    /*
     AppState.Coordinating should contain data which is needed to transition from one screen to another
     */
    struct Coordinating: Equatable {
        var auth = AuthCoordinator.Coordinating.login
    }
}

extension AppState {
    struct Application: Equatable {
        var isActive: Bool = false
        var keyboardHeight: CGFloat = 0
    }
}

func == (lhs: AppState, rhs: AppState) -> Bool {
    return lhs.data == rhs.data &&
           lhs.coordinating == rhs.coordinating &&
           lhs.application == rhs.application
}
