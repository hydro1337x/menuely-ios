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
    func getUserProfile(user: LoadableSubject<User>)
    func uploadImageAndGetUserProfile(with dataParameters: DataParameters, ofKind kind: ImageKind, user: LoadableSubject<User>)
    func uploadImage(with dataParameters: DataParameters, ofKind kind: ImageKind, imageResult: LoadableSubject<Discardable>)
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
    
    func getUserProfile(user: LoadableSubject<User>) {
        user.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.getUserProfile()
            }
            .map { $0.data }
            .sinkToLoadable { user.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func uploadImageAndGetUserProfile(with dataParameters: DataParameters, ofKind kind: ImageKind, user: LoadableSubject<User>) {
        user.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.uploadImage(with: kind.asParameter, and: dataParameters)
            }
            .flatMap { [remoteRepository] _ in
                remoteRepository.getUserProfile()
            }
            .map { $0.data }
            .sinkToLoadable { user.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func uploadImage(with dataParameters: DataParameters, ofKind kind: ImageKind, imageResult: LoadableSubject<Discardable>) {
        imageResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.uploadImage(with: kind.asParameter, and: dataParameters)
            }
            .sinkToLoadable { imageResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}
