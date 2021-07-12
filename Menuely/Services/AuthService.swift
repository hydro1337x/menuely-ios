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
    func loginUser(with userLoginRequestDTO: UserLoginRequestDTO, userAuth: LoadableSubject<UserAuth>)
    
    func registerRestaurant(with restaurantRegistrationRequestDTO: RestaurantRegistrationRequestDTO, registration: LoadableSubject<Discardable>)
    func loginRestaurant(with restaurantLoginRequestDTO: RestaurantLoginRequestDTO, restaurantAuth: LoadableSubject<RestaurantAuth>)
}

class AuthService: AuthServicing {
    
   @Injected private var remoteRepository: AuthRemoteRepositing
    
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
    
    func loginUser(with userLoginRequestDTO: UserLoginRequestDTO, userAuth: LoadableSubject<UserAuth>) {
        userAuth.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                return remoteRepository.loginUser(userLoginRequestDTO: userLoginRequestDTO)
            }
            .map { $0.data }
            .sinkToLoadable { userAuth.wrappedValue = $0 }
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
    
    func loginRestaurant(with restaurantLoginRequestDTO: RestaurantLoginRequestDTO, restaurantAuth: LoadableSubject<RestaurantAuth>) {
        restaurantAuth.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                return remoteRepository.loginRestaurant(restaurantLoginRequestDTO: restaurantLoginRequestDTO)
            }
            .map { $0.data }
            .sinkToLoadable { restaurantAuth.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}
