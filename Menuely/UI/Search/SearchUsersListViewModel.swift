//
//  SearchUsersListViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 31.07.2021..
//

import Foundation
import Resolver

extension SearchUsersListView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        @Injected private var usersService: UsersServicing
        
        @Published var users: Loadable<[User]>
        @Published var search: String = ""
        
        var appState: Store<AppState>
        private var cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>, users: Loadable<[User]> = .notRequested) {
            self.appState = appState
            
            _users = .init(initialValue: users)
            
            $search
                .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { [weak self] in
                    self?.getUsers(with: $0)
                }
                .store(in: cancelBag)
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
