//
//  AuthRemoteRepository.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 07.07.2021..
//

import Foundation
import Combine
import Resolver

protocol AuthRemoteRepositing {
    func registerUser(userRegistrationRequestDTO: UserRegistrationRequestDTO) -> AnyPublisher<Discardable, Error>
    func loginUser(userLoginRequestDTO: LoginRequestDTO) -> AnyPublisher<UserLoginResponseDTO, Error>
    
    func registerRestaurant(restaurantRegistrationRequestDTO: RestaurantRegistrationRequestDTO) -> AnyPublisher<Discardable, Error>
    func loginRestaurant(restaurantLoginRequestDTO: LoginRequestDTO) -> AnyPublisher<RestaurantLoginResponseDTO, Error>
}

class AuthRemoteRepository: AuthRemoteRepositing {
    @Injected private var networkClient: Networking
    
    func registerUser(userRegistrationRequestDTO: UserRegistrationRequestDTO) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.registerUser(userRegistrationRequestDTO))
    }

    func loginUser(userLoginRequestDTO: LoginRequestDTO) -> AnyPublisher<UserLoginResponseDTO, Error> {
        networkClient.request(endpoint: Endpoint.loginUser(userLoginRequestDTO))
    }
    
    func registerRestaurant(restaurantRegistrationRequestDTO: RestaurantRegistrationRequestDTO) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.registerRestaurant(restaurantRegistrationRequestDTO))
    }
    
    func loginRestaurant(restaurantLoginRequestDTO: LoginRequestDTO) -> AnyPublisher<RestaurantLoginResponseDTO, Error> {
        networkClient.request(endpoint: Endpoint.loginRestaurant(restaurantLoginRequestDTO))
    }
}

extension AuthRemoteRepository {
    enum Endpoint {
        case registerUser(_: UserRegistrationRequestDTO)
        case loginUser(_: LoginRequestDTO)
        case registerRestaurant(_: RestaurantRegistrationRequestDTO)
        case loginRestaurant(_: LoginRequestDTO)
    }
}

extension AuthRemoteRepository.Endpoint: APIConfigurable {
    var path: String {
        switch self {
        case .registerUser(_): return "/auth/register/user"
        case .loginUser(_): return "/auth/login/user"
        case .registerRestaurant(_): return "/auth/register/restaurant"
        case .loginRestaurant(_): return "/auth/login/restaurant"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .registerUser(_): return .post
        case .loginUser(_): return .post
        case .registerRestaurant(_): return .post
        case .loginRestaurant(_): return .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .registerUser(_), .loginUser(_), .registerRestaurant(_), .loginRestaurant(_): return ["Content-Type": "application/json"]
        }
    }
    
    var queryParameters: Parameters? {
        return nil
    }
    
    func body() throws -> Data? {
        switch self {
        case .registerUser(let userRegistrationRequestDTO): return try userRegistrationRequestDTO.asJSON()
        case .loginUser(let userLoginRequestDTO): return try userLoginRequestDTO.asJSON()
        case .registerRestaurant(let restaurantRegistrationRequestDTO): return try restaurantRegistrationRequestDTO.asJSON()
        case .loginRestaurant(let restaurantLoginRequestDTO): return try restaurantLoginRequestDTO.asJSON()
        }
    }
}
