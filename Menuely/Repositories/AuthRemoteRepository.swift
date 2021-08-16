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
    
    func resetUserPassword(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error>
    func resetRestaurantPassword(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error>
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
    
    func resetUserPassword(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.resetUserPassword(bodyRequest))
    }
    
    func resetRestaurantPassword(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.resetRestaurantPassword(bodyRequest))
    }
}

extension AuthRemoteRepository {
    enum Endpoint {
        case registerUser(BodyRequestable)
        case loginUser(BodyRequestable)
        case registerRestaurant(BodyRequestable)
        case loginRestaurant(BodyRequestable)
        case logout(BodyRequestable)
        case resetUserPassword(BodyRequestable)
        case resetRestaurantPassword(BodyRequestable)
    }
}

extension AuthRemoteRepository.Endpoint: APIConfigurable {
    var path: String {
        switch self {
        case .registerUser: return "/auth/register/user"
        case .loginUser: return "/auth/login/user"
        case .registerRestaurant: return "/auth/register/restaurant"
        case .loginRestaurant: return "/auth/login/restaurant"
        case .logout: return "/auth/logout"
        case .resetUserPassword: return "/auth/reset-password/user"
        case .resetRestaurantPassword: return "/auth/reset-password/restaurant"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .registerUser: return .post
        case .loginUser: return .post
        case .registerRestaurant: return .post
        case .loginRestaurant: return .post
        case .logout: return .delete
        case .resetUserPassword: return .post
        case .resetRestaurantPassword: return .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .registerUser, .loginUser, .registerRestaurant, .loginRestaurant, .logout, .resetUserPassword, .resetRestaurantPassword: return ["Content-Type": "application/json"]
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
        case .resetUserPassword(let bodyRequest): return bodyRequest
        case .resetRestaurantPassword(let bodyRequest): return bodyRequest
        }
    }
    
    var multipartFormDataRequestable: MultipartFormDataRequestable? {
        return nil
    }
}
