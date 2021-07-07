//
//  UsersService.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.07.2021..
//

import Foundation
import Combine
import Resolver

protocol UsersServicing {
    func get(users: LoadableSubject<[User]>, search: String)
}

struct UsersService: UsersServicing {
    @Injected var appState: Store<AppState>
    @Injected var remoteRepository: UsersRemoteRepositing
    
    func get(users: LoadableSubject<[User]>, search: String) {
        let cancelBag = CancelBag()
        
        users.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                return remoteRepository.getUsers()
            }
            .map { return $0.users }
            .sinkToLoadable { users.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}
