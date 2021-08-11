//
//  RestaurantsRemoteRepository.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 22.07.2021..
//

import Foundation
import Resolver
import Combine
import Alamofire

protocol RestaurantsRemoteRepositing {
    func getRestaurant(with id: PathParameter) -> AnyPublisher<RestaurantResponse, Error>
    func getRestaurants(with queryRequestable: QueryRequestable?) -> AnyPublisher<RestaurantsListResponse, Error>
    func getRestaurantProfile() -> AnyPublisher<RestaurantResponse, Error>
    func uploadImage(with multipartFormDataRequestable: MultipartFormDataRequestable) -> AnyPublisher<Discardable, Error>
    func updateRestaurantProfile(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error>
    func updateRestaurantPassword(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error>
    func updateRestaurantEmail(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error>
    func deleteRestaurantProfile() -> AnyPublisher<Discardable, Error>
    func getEmployees() -> AnyPublisher<UsersListResponse, Error>
}

class RestaurantsRemoteRepository: RestaurantsRemoteRepositing {
    @Injected private var networkClient: Networking
    
    func getRestaurant(with id: PathParameter) -> AnyPublisher<RestaurantResponse, Error> {
        networkClient.request(endpoint: Endpoint.restaurant(id))
    }
    
    func getRestaurants(with queryRequestable: QueryRequestable?) -> AnyPublisher<RestaurantsListResponse, Error> {
        networkClient.request(endpoint: Endpoint.restaurants(queryRequestable))
    }
    
    func getRestaurantProfile() -> AnyPublisher<RestaurantResponse, Error> {
        networkClient.request(endpoint: Endpoint.restaurantProfile)
    }
    
    func uploadImage(with multipartFormDataRequestable: MultipartFormDataRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.upload(multipartFormDataRequestable))
    }
    
    func updateRestaurantProfile(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.updateRestaurantProfile(bodyRequest))
    }
    
    func updateRestaurantPassword(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.updateRestaurantPassword(bodyRequest))
    }
    
    func updateRestaurantEmail(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.updateRestaurantEmail(bodyRequest))
    }
    
    func deleteRestaurantProfile() -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.delete)
    }
    
    func getEmployees() -> AnyPublisher<UsersListResponse, Error> {
        networkClient.request(endpoint: Endpoint.employees)
    }
}

// MARK: - Endpoints

extension RestaurantsRemoteRepository {
    enum Endpoint {
        case restaurant(PathParameter)
        case restaurants(QueryRequestable?)
        case restaurantProfile
        case upload(_: MultipartFormDataRequestable)
        case updateRestaurantProfile(_: BodyRequestable)
        case updateRestaurantPassword(_: BodyRequestable)
        case updateRestaurantEmail(_: BodyRequestable)
        case delete
        case employees
    }
}

extension RestaurantsRemoteRepository.Endpoint: APIConfigurable {
    var path: String {
        switch self {
        case .restaurant(let id): return "/restaurants/\(id)"
        case .restaurants: return "/restaurants"
        case .restaurantProfile: return "/restaurants/me"
        case .upload: return "/restaurants/me/image"
        case .updateRestaurantProfile: return "/restaurants/me/profile"
        case .updateRestaurantPassword: return "/restaurants/me/password"
        case .updateRestaurantEmail: return "/restaurants/me/email"
        case .delete: return "/restaurants/me"
        case .employees: return "/restaurants/me/employees"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .restaurant: return .get
        case .restaurants: return .get
        case .restaurantProfile: return .get
        case .upload: return .patch
        case .updateRestaurantProfile: return .patch
        case .updateRestaurantPassword: return .patch
        case .updateRestaurantEmail: return .patch
        case .delete: return .delete
        case .employees: return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .restaurant: return nil
        case .restaurants: return nil
        case .restaurantProfile: return nil
        case .upload: return nil
        case .updateRestaurantProfile: return ["Content-Type": "application/json"]
        case .updateRestaurantPassword: return ["Content-Type": "application/json"]
        case .updateRestaurantEmail: return ["Content-Type": "application/json"]
        case .delete: return nil
        case .employees: return ["Content-Type": "application/json"]
        }
    }
    
    var queryRequestable: QueryRequestable? {
        switch self {
        case .restaurants(let queryRequestable): return queryRequestable
        default: return nil
        }
    }
    
    var bodyRequestable: BodyRequestable? {
        switch self {
        case .restaurant: return nil
        case .restaurants: return nil
        case .restaurantProfile: return nil
        case .upload: return nil
        case .updateRestaurantProfile(let bodyRequest): return bodyRequest
        case .updateRestaurantPassword(let bodyRequest): return bodyRequest
        case .updateRestaurantEmail(let bodyRequest): return bodyRequest
        case .delete: return nil
        case .employees: return nil
        }
    }
    
    var multipartFormDataRequestable: MultipartFormDataRequestable? {
        switch self {
        case .upload(let multipartFormDataRequestable): return multipartFormDataRequestable
        default: return nil
        }
    }
}
