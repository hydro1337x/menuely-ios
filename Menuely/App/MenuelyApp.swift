//
//  MenuelyApp.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 28.06.2021..
//

import SwiftUI
import Resolver

@main
struct MenuelyApp: App {
    @Injected private var appEventsHandler: AppEventsHandler
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
