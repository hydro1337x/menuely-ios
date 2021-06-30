//
//  AppState.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.06.2021..
//

import SwiftUI
import Combine

struct AppState: Equatable {
    var userData = UserData()
    var routing = ViewRouting()
    var application = Application()
}

extension AppState {
    struct UserData: Equatable {
        
    }
}

extension AppState {
    struct ViewRouting: Equatable {
        
    }
}

extension AppState {
    struct Application: Equatable {
        var isActive: Bool = false
        var keyboardHeight: CGFloat = 0
    }
}

func == (lhs: AppState, rhs: AppState) -> Bool {
    return lhs.userData == rhs.userData &&
           lhs.routing == rhs.routing &&
           lhs.application == rhs.application
}
