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
    func updateUserProfile(with updateUserProfileRequestDTO: UpdateUserProfileRequestDTO, updateProfileResult: LoadableSubject<Discardable>)
    func updateUserPassword(with updatePasswordRequestDTO: UpdatePasswordRequestDTO, updatePasswordResult: LoadableSubject<Discardable>)
    func updateUserEmail(with updateEmailRequestDTO: UpdateEmailRequestDTO, updateEmailResult: LoadableSubject<Discardable>)
    func delete(deletionResult: LoadableSubject<Discardable>)
}

class UsersService: UsersServicing {
    @Injected private var appState: Store<AppState>
    @Injected private var remoteRepository: UsersRemoteRepositing
    @Injected private var localRepository: LocalRepositing
    
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
            .map { $0.user }
            .sinkToLoadable {
                user.wrappedValue = $0
                
                self.updateUser($0.value)
            }
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
            .map { $0.user }
            .sinkToLoadable {
                user.wrappedValue = $0
                
                self.updateUser($0.value)
            }
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
    
    func updateUserProfile(with updateUserProfileRequestDTO: UpdateUserProfileRequestDTO, updateProfileResult: LoadableSubject<Discardable>) {
        updateProfileResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.updateUserProfile(with: updateUserProfileRequestDTO)
            }
            .sinkToLoadable { updateProfileResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func updateUserPassword(with updatePasswordRequestDTO: UpdatePasswordRequestDTO, updatePasswordResult: LoadableSubject<Discardable>) {
        updatePasswordResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.updateUserPassword(with: updatePasswordRequestDTO)
            }
            .sinkToLoadable { updatePasswordResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func updateUserEmail(with updateEmailRequestDTO: UpdateEmailRequestDTO, updateEmailResult: LoadableSubject<Discardable>) {
        updateEmailResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.updateUserEmail(with: updateEmailRequestDTO)
            }
            .sinkToLoadable { updateEmailResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func delete(deletionResult: LoadableSubject<Discardable>) {
        deletionResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.delete()
            }
            .sinkToLoadable {
                deletionResult.wrappedValue = $0
                
                if $0.value != nil {
                    self.removeAuthenticatedUser()
                }
            }
            .store(in: cancelBag)
    }
    
    func updateUser(_ user: User?) {
        guard let tokens = appState[\.data.authenticatedUser]?.auth, let user = user else { return }
        let updatedAuthenticatedUser = AuthenticatedUser(user: user, auth: tokens)
        appState[\.data.authenticatedUser] = updatedAuthenticatedUser
    }
    
    private func removeAuthenticatedUser() {
        localRepository.removeValue(for: .authenticatedUser)
    }
}
