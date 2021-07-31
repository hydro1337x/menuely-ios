//
//  UsersService.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.07.2021..
//

import Foundation
import Combine
import Resolver
import Alamofire

protocol UsersServicing {
    func getUsers(with queryRequestable: QueryRequestable?, users: LoadableSubject<[User]>)
    func getUserProfile(user: LoadableSubject<User>)
    func uploadImageAndGetUserProfile(with multipartFormDataRequestable: MultipartFormDataRequestable, user: LoadableSubject<User>)
    func uploadImage(with multipartFormDataRequestable: MultipartFormDataRequestable, imageResult: LoadableSubject<Discardable>)
    func updateUserProfile(with bodyRequest: BodyRequestable, updateProfileResult: LoadableSubject<Discardable>)
    func updateUserPassword(with bodyRequest: BodyRequestable, updatePasswordResult: LoadableSubject<Discardable>)
    func updateUserEmail(with bodyRequest: BodyRequestable, updateEmailResult: LoadableSubject<Discardable>)
    func delete(deletionResult: LoadableSubject<Discardable>)
}

class UsersService: UsersServicing {
    @Injected private var appState: Store<AppState>
    @Injected private var remoteRepository: UsersRemoteRepositing
    @Injected private var localRepository: LocalRepositing
    
    let cancelBag = CancelBag()
    
    func getUsers(with queryRequestable: QueryRequestable?, users: LoadableSubject<[User]>) {
        users.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                return remoteRepository.getUsers(with: queryRequestable)
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
    
    func uploadImageAndGetUserProfile(with multipartFormDataRequestable: MultipartFormDataRequestable, user: LoadableSubject<User>) {
        user.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.uploadImage(with: multipartFormDataRequestable)
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
    
    func uploadImage(with multipartFormDataRequestable: MultipartFormDataRequestable, imageResult: LoadableSubject<Discardable>) {
        imageResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.uploadImage(with: multipartFormDataRequestable)
            }
            .sinkToLoadable { imageResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func updateUserProfile(with bodyRequest: BodyRequestable, updateProfileResult: LoadableSubject<Discardable>) {
        updateProfileResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.updateUserProfile(with: bodyRequest)
            }
            .sinkToLoadable { updateProfileResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func updateUserPassword(with bodyRequest: BodyRequestable, updatePasswordResult: LoadableSubject<Discardable>) {
        updatePasswordResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.updateUserPassword(with: bodyRequest)
            }
            .sinkToLoadable { updatePasswordResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func updateUserEmail(with bodyRequest: BodyRequestable, updateEmailResult: LoadableSubject<Discardable>) {
        updateEmailResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.updateUserEmail(with: bodyRequest)
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
