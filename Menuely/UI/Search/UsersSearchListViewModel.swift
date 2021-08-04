//
//  UsersSearchListViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 31.07.2021..
//

import Foundation
import Resolver

extension UsersSearchListView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        @Injected private var usersService: UsersServicing
        
        @Published var routing: Routing
        @Published var users: Loadable<[User]>
        
        var appState: Store<AppState>
        private var cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>, users: Loadable<[User]> = .notRequested) {
            self.appState = appState
            
            _routing = .init(initialValue: appState[\.routing.usersSearch])
            
            _users = .init(initialValue: users)
            
            cancelBag.collect {
                appState
                    .map(\.data.searchList.search)
                    .removeDuplicates()
                    .compactMap { $0 }
                    .sink { [weak self] in
                        self?.getUsers(with: $0)
                    }
                
                $routing
                    .removeDuplicates()
                    .sink { appState[\.routing.usersSearch] = $0 }
                
                appState
                    .map(\.routing.usersSearch)
                    .removeDuplicates()
                    .assign(to: \.routing, on: self)
            }
                
        }
        
        // MARK: - Methods
        func getUsers(with search: String) {
            let queryRequest = SearchQueryRequest(search: search)
            usersService.getUsers(with: queryRequest, users: loadableSubject(\.users))
        }
        
        func resetStates() {
            users.reset()
        }
        
        // MARK: - Routing
        func errorView(with message: String?) {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
        }
    }
}
