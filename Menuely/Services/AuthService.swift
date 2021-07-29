//
//  AuthService.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 07.07.2021..
//

import Foundation
import Combine
import Resolver


protocol AuthServicing {
    var currentAuthenticatedEntity: EntityType? { get }
    var authenticatedUser: AuthenticatedUser? { get }
    var authenticatedRestaurant: AuthenticatedRestaurant? { get }
    
    func registerUser(with bodyRequest: BodyRequestable, registration: LoadableSubject<Discardable>)
    func loginUser(with userbodyRequest: BodyRequestable, authenticatedUser: LoadableSubject<AuthenticatedUser>)
    
    func registerRestaurant(with bodyRequest: BodyRequestable, registration: LoadableSubject<Discardable>)
    func loginRestaurant(with restaurantbodyRequest: BodyRequestable, authenticatedRestaurant: LoadableSubject<AuthenticatedRestaurant>)
    
    func logout(logoutResult: LoadableSubject<Discardable>)
}

class AuthService: AuthServicing {
    
    @Injected private var remoteRepository: AuthRemoteRepositing
    @Injected private var appState: Store<AppState>
    @Injected private var localRepository: LocalRepositing
    
    var cancelBag = CancelBag()
    
    // MARK: - Computed Properties
    var currentAuthenticatedEntity: EntityType? {
        if authenticatedUser != nil { return .user }
        if authenticatedRestaurant != nil { return .restaurant }
        return nil
    }
    
    var authenticatedUser: AuthenticatedUser? {
        return localRepository.load(AuthenticatedUser.self, for: .authenticatedUser)
    }
    
    var authenticatedRestaurant: AuthenticatedRestaurant? {
        return localRepository.load(AuthenticatedRestaurant.self, for: .authenticatedRestaurant)
    }
    
    // MARK: - User
    
    func registerUser(with bodyRequest: BodyRequestable, registration: LoadableSubject<Discardable>) {
        registration.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                return remoteRepository.registerUser(bodyRequest: bodyRequest)
            }
            .sinkToLoadable { registration.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func loginUser(with userbodyRequest: BodyRequestable, authenticatedUser: LoadableSubject<AuthenticatedUser>) {
        authenticatedUser.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                return remoteRepository.loginUser(userbodyRequest: userbodyRequest)
            }
            .map { $0.authenticatedUser }
            .sinkToLoadable {
                authenticatedUser.wrappedValue = $0
                
                if let authenticatedUser = $0.value {
                    self.saveAuthenticatedUser(authenticatedUser)
                }
            }
            .store(in: cancelBag)
    }
    
    // MARK: - Restaurant
    
    func registerRestaurant(with bodyRequest: BodyRequestable, registration: LoadableSubject<Discardable>) {
        registration.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                return remoteRepository.registerRestaurant(bodyRequest: bodyRequest)
            }
            .sinkToLoadable { registration.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func loginRestaurant(with restaurantbodyRequest: BodyRequestable, authenticatedRestaurant: LoadableSubject<AuthenticatedRestaurant>) {
        authenticatedRestaurant.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                return remoteRepository.loginRestaurant(restaurantbodyRequest: restaurantbodyRequest)
            }
            .map { $0.authenticatedRestaurant }
            .sinkToLoadable {
                authenticatedRestaurant.wrappedValue = $0
                
                if let authenticatedRestaurant = $0.value {
                    self.saveAuthenticatedRestaurant(authenticatedRestaurant)
                }
                
            }
            .store(in: cancelBag)
    }
    
    // MARK: - General
    func logout(logoutResult: LoadableSubject<Discardable>) {
        logoutResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        let tokens = getTokens()
        
        guard let tokens = tokens else {
            logoutResult.wrappedValue = .failed(NetworkError.refreshTokenMissing)
            return
        }
        
        let bodyRequest = LogoutBodyRequest(refreshToken: tokens.refreshToken)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                return remoteRepository.logout(with: bodyRequest)
            }
            .sinkToLoadable {
                logoutResult.wrappedValue = $0
                
                if $0.value != nil {
                    self.removeAuthenticatedEntity()
                }
            }
            .store(in: cancelBag)
    }
    
    private func saveAuthenticatedUser(_ authenticatedUser: AuthenticatedUser?) {
        localRepository.save(authenticatedUser, for: .authenticatedUser)
        appState[\.data.authenticatedUser] = authenticatedUser
    }
    
    private func saveAuthenticatedRestaurant(_ authenticatedRestaurant: AuthenticatedRestaurant?) {
        localRepository.save(authenticatedRestaurant, for: .authenticatedRestaurant)
        appState[\.data.authenticatedRestaurant] = authenticatedRestaurant
    }
    
    private func removeAuthenticatedEntity() {
        localRepository.removeValue(for: .authenticatedUser)
        localRepository.removeValue(for: .authenticatedRestaurant)
    }
    
    private func getTokens() -> Tokens? {
        switch appState[\.data.selectedEntity] {
        case .user:
             return authenticatedUser?.auth
        case .restaurant:
            return authenticatedRestaurant?.auth
        }
    }
}
