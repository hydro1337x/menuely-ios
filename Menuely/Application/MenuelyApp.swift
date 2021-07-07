//
//  MenuelyApp.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 28.06.2021..
//

import SwiftUI
import Resolver
import Combine

@main
struct MenuelyApp: App {
    @Injected private var applicationEventsHandler: ApplicationEventsHandler
    @Injected private var usersRepository: UsersRemoteRepositing
    
    var cancelBag = CancelBag()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
