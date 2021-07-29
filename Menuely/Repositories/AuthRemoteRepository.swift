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
    func registerUser(bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error>
    func loginUser(userbodyRequest: BodyRequestable) -> AnyPublisher<UserLoginResponse, Error>
    
    func registerRestaurant(bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error>
    func loginRestaurant(restaurantbodyRequest: BodyRequestable) -> AnyPublisher<RestaurantLoginResponse, Error>
    
    func logout(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error>
}

class AuthRemoteRepository: AuthRemoteRepositing {
    @Injected private var networkClient: Networking
    
    func registerUser(bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.registerUser(bodyRequest))
    }

    func loginUser(userbodyRequest: BodyRequestable) -> AnyPublisher<UserLoginResponse, Error> {
        networkClient.request(endpoint: Endpoint.loginUser(userbodyRequest))
    }
    
    func registerRestaurant(bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.registerRestaurant(bodyRequest))
    }
    
    func loginRestaurant(restaurantbodyRequest: BodyRequestable) -> AnyPublisher<RestaurantLoginResponse, Error> {
        networkClient.request(endpoint: Endpoint.loginRestaurant(restaurantbodyRequest))
    }
    
    func logout(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.logout(bodyRequest))
    }
}

extension AuthRemoteRepository {
    enum Endpoint {
        case registerUser(_: BodyRequestable)
        case loginUser(_: BodyRequestable)
        case registerRestaurant(_: BodyRequestable)
        case loginRestaurant(_: BodyRequestable)
        case logout(_: BodyRequestable)
    }
}

extension AuthRemoteRepository.Endpoint: APIConfigurable {
    var path: String {
        switch self {
        case .registerUser(_): return "/auth/register/user"
        case .loginUser(_): return "/auth/login/user"
        case .registerRestaurant(_): return "/auth/register/restaurant"
        case .loginRestaurant(_): return "/auth/login/restaurant"
        case .logout(_): return "/auth/logout"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .registerUser(_): return .post
        case .loginUser(_): return .post
        case .registerRestaurant(_): return .post
        case .loginRestaurant(_): return .post
        case .logout(_): return .delete
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .registerUser(_), .loginUser(_), .registerRestaurant(_), .loginRestaurant(_), .logout(_): return ["Content-Type": "application/json"]
        }
    }
    
    var queryRequestable: QueryRequestable? {
        return nil
    }
    
    var bodyRequestable: BodyRequestable? {
        switch self {
        case .registerUser(let bodyRequest): return bodyRequest
        case .loginUser(let userbodyRequest): return userbodyRequest
        case .registerRestaurant(let bodyRequest): return bodyRequest
        case .loginRestaurant(let bodyRequest): return bodyRequest
        case .logout(let bodyRequest): return bodyRequest
        }
    }
    
    var multipartFormDataRequestable: MultipartFormDataRequestable? {
        return nil
    }
}
