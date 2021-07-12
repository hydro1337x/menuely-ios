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
    var routing = Routing()
    var application = Application()
}

extension AppState {
    /* AppState.Data should contain data which is shared across the whole application, since AppState is always wrapped with the Store typealias which on its own is a CurrentValueSubject, it will emit all changes if a property is mutated and all views which use that data can stay in sync
     */
    struct Data: Equatable {
        var tokens: Tokens?
        var selectedEntity: EntityType = .none
    }
}

extension AppState {
    /*
     AppState.Routing should contain data which is needed to transition from one screen to another
     */
    struct Routing: Equatable {
        
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
           lhs.routing == rhs.routing &&
           lhs.application == rhs.application
}
