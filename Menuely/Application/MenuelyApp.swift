//
//  MenuelyApp.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 28.06.2021..
//

import SwiftUI
import Combine
import Resolver

@main
struct MenuelyApp: App {
    @Injected private var applicationEventsHandler: ApplicationEventsHandler
    var cancelBag = CancelBag()
    @Injected private var secureLocalRepository: SecureLocalRepositing
    
    var body: some Scene {
        WindowGroup {
            RootCoordinatorView()
                .modifier(RootViewAppearance())
        }
    }
}
