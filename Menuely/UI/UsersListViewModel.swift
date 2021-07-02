//
//  UsersListViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.07.2021..
//

import Foundation
import Resolver

class UsersListViewModel: ObservableObject {
    @Published var users: Loadable<Users>
    
    @Injected var usersService: UsersServicing
    private var cancelBag = CancelBag()
    
    init(users: Loadable<Users> = .notRequested) {
        _users = .init(initialValue: users)
    }
    
    func getUsers() {
        usersService.get(users: loadableSubject(\.users), search: "")
    }
}
