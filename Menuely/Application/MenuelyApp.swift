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
    @Injected private var remoteRepository: AuthRemoteRepositing
    
    var cancelBag = CancelBag()
    
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear(perform: {
                remoteRepository.loginUser(userLoginRequestDTO: UserLoginRequestDTO(email: "user6@email.com", password: "qqqqqq")).sinkToLoadable { completion in
                    print(completion.value)
                }.store(in: cancelBag)
            })
        }
    }
}
