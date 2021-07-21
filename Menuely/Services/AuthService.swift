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
    
    func registerUser(with userRegistrationRequestDTO: UserRegistrationRequestDTO, registration: LoadableSubject<Discardable>)
    func loginUser(with userLoginRequestDTO: LoginRequestDTO, authenticatedUser: LoadableSubject<AuthenticatedUser>)
    
    func registerRestaurant(with restaurantRegistrationRequestDTO: RestaurantRegistrationRequestDTO, registration: LoadableSubject<Discardable>)
    func loginRestaurant(with restaurantLoginRequestDTO: LoginRequestDTO, authenticatedRestaurant: LoadableSubject<AuthenticatedRestaurant>)
    
    func logout(logoutResult: LoadableSubject<Discardable>)
}

class AuthService: AuthServicing {
    
    @Injected private var remoteRepository: AuthRemoteRepositing
    @Injected private var appState: Store<AppState>
    @Injected private var secureLocalRepository: SecureLocalRepositing
    
    var cancelBag = CancelBag()
    
    // MARK: - Computed Properties
    var currentAuthenticatedEntity: EntityType? {
        let authenticatedUser = secureLocalRepository.load(AuthenticatedUser.self, for: .authenticatedUser)
        let authenticatedRestaurant = secureLocalRepository.load(AuthenticatedRestaurant.self, for: .authenticatedRestaurant)
        if authenticatedUser != nil { return .user }
        if authenticatedRestaurant != nil { return .restaurant }
        return nil
    }
    
    var authenticatedUser: AuthenticatedUser? {
        return secureLocalRepository.load(AuthenticatedUser.self, for: .authenticatedUser)
    }
    
    var authenticatedRestaurant: AuthenticatedRestaurant? {
        return secureLocalRepository.load(AuthenticatedRestaurant.self, for: .authenticatedRestaurant)
    }
    
    // MARK: - User
    
    func registerUser(with userRegistrationRequestDTO: UserRegistrationRequestDTO, registration: LoadableSubject<Discardable>) {
        registration.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                return remoteRepository.registerUser(userRegistrationRequestDTO: userRegistrationRequestDTO)
            }
            .sinkToLoadable { registration.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    // TODO: - Move mapping logic from VM-s to there
    func loginUser(with userLoginRequestDTO: LoginRequestDTO, authenticatedUser: LoadableSubject<AuthenticatedUser>) {
        authenticatedUser.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                return remoteRepository.loginUser(userLoginRequestDTO: userLoginRequestDTO)
            }
            .map { $0.data }
            .sinkToLoadable {
                authenticatedUser.wrappedValue = $0
                
                if let authenticatedUser = $0.value {
                    self.saveAuthenticatedUser(authenticatedUser)
                }
            }
            .store(in: cancelBag)
    }
    
    // MARK: - Restaurant
    
    func registerRestaurant(with restaurantRegistrationRequestDTO: RestaurantRegistrationRequestDTO, registration: LoadableSubject<Discardable>) {
        registration.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                return remoteRepository.registerRestaurant(restaurantRegistrationRequestDTO: restaurantRegistrationRequestDTO)
            }
            .sinkToLoadable { registration.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func loginRestaurant(with restaurantLoginRequestDTO: LoginRequestDTO, authenticatedRestaurant: LoadableSubject<AuthenticatedRestaurant>) {
        authenticatedRestaurant.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                return remoteRepository.loginRestaurant(restaurantLoginRequestDTO: restaurantLoginRequestDTO)
            }
            .map { $0.data }
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
        
        let authenticatedUser = secureLocalRepository.load(AuthenticatedUser.self, for: .authenticatedUser)
        let authenticatedRestaurant = secureLocalRepository.load(AuthenticatedRestaurant.self, for: .authenticatedRestaurant)
        let tokens = authenticatedUser?.auth ?? authenticatedRestaurant?.auth
        
        guard let tokens = tokens else {
            logoutResult.wrappedValue = .failed(NetworkError.refreshTokenMissing)
            return
        }
        
        let logoutRequestDTO = LogoutRequestDTO(refreshToken: tokens.refreshToken)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                return remoteRepository.logout(with: logoutRequestDTO)
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
        secureLocalRepository.save(authenticatedUser, for: .authenticatedUser)
        appState[\.data.authenticatedUser] = authenticatedUser
    }
    
    private func saveAuthenticatedRestaurant(_ authenticatedRestaurant: AuthenticatedRestaurant?) {
        secureLocalRepository.save(authenticatedRestaurant, for: .authenticatedRestaurant)
        appState[\.data.authenticatedRestaurant] = authenticatedRestaurant
    }
    
    private func removeAuthenticatedEntity() {
        secureLocalRepository.removeValue(for: .authenticatedUser)
        secureLocalRepository.removeValue(for: .authenticatedRestaurant)
        appState[\.data.authenticatedUser] = nil
        appState[\.data.authenticatedRestaurant] = nil
    }
}
