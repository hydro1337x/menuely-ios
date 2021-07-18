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
    func registerUser(with userRegistrationRequestDTO: UserRegistrationRequestDTO, registration: LoadableSubject<Discardable>)
    func loginUser(with userLoginRequestDTO: LoginRequestDTO, authenticatedUser: LoadableSubject<AuthenticatedUser>)
    
    func registerRestaurant(with restaurantRegistrationRequestDTO: RestaurantRegistrationRequestDTO, registration: LoadableSubject<Discardable>)
    func loginRestaurant(with restaurantLoginRequestDTO: LoginRequestDTO, authenticatedRestaurant: LoadableSubject<AuthenticatedRestaurant>)
}

class AuthService: AuthServicing {
    
    @Injected private var remoteRepository: AuthRemoteRepositing
    @Injected private var appState: Store<AppState>
    @Injected private var secureLocalRepository: SecureLocalRepositing
    
    var cancelBag = CancelBag()
    
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
                
                self.saveAuthenticatedUser($0.value)
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
                
                self.saveAuthenticatedRestaurant($0.value)
            }
            .store(in: cancelBag)
    }
    
    // MARK: - GeneralauthenticatedRestaurant
    
    private func saveAuthenticatedUser(_ authenticatedUser: AuthenticatedUser?) {
        secureLocalRepository.save(authenticatedUser, for: .authenticatedUser)
        appState[\.data.authenticatedUser] = authenticatedUser
    }
    
    private func saveAuthenticatedRestaurant(_ authenticatedRestaurant: AuthenticatedRestaurant?) {
        secureLocalRepository.save(authenticatedRestaurant, for: .authenticatedRestaurant)
        appState[\.data.authenticatedRestaurant] = authenticatedRestaurant
    }
}
