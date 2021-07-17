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
    func uploadImage(with dataParameters: DataParameters, ofKind kind: ImageKind)
}

class UsersService: UsersServicing {
    @Injected var appState: Store<AppState>
    @Injected var remoteRepository: UsersRemoteRepositing
    
    let cancelBag = CancelBag()
    
    func get(users: LoadableSubject<[User]>, search: String) {
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
    
    func uploadImage(with dataParameters: DataParameters, ofKind kind: ImageKind) {
        remoteRepository.uploadImage(with: kind.asParameter, and: dataParameters)
            .sink { completion in
                print("Upload complete: ", completion)
            } receiveValue: { discardable in
//                print(discardable)
            }
            .store(in: cancelBag)

    }
}
