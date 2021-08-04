//
//  UserNoticeViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 04.08.2021..
//

import Foundation
import Resolver

extension UserNoticeView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        @Injected private var usersService: UsersServicing
        
        @Published var user: Loadable<User>
        
        var appState: Store<AppState>
        private let cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>, user: Loadable<User> = .notRequested) {
            self.appState = appState
            
            _user = .init(initialValue: user)
        }
        
        // MARK: - Methods
        func getUser() {
            guard let id = appState[\.routing.usersSearch.userNoticeForID] else { return }
            usersService.getUser(with: id, user: loadableSubject(\.user))
        }
        
        // MARK: - Routing
        func errorView(with message: String?) {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
        }
    }
}
