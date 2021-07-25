//
//  RestaurantsRemoteRepository.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 22.07.2021..
//

import Foundation
import Resolver
import Combine
import UIKit

protocol RestaurantsRemoteRepositing {
    func getRestaurants(with searchRequestDTO: SearchRequestDTO?) -> AnyPublisher<RestaurantListResponseDTO, Error>
    func getRestaurantProfile() -> AnyPublisher<RestaurantResponseDTO, Error>
    func uploadImage(with parameters: [String: String], and dataParameters: DataParameters) -> AnyPublisher<Discardable, Error>
    func updateRestaurantProfile(with restaurantUpdateProfileRequestDTO: RestaurantUpdateProfileRequestDTO) -> AnyPublisher<Discardable, Error>
    func updateRestaurantPassword(with updatePasswordRequestDTO: UpdatePasswordRequestDTO) -> AnyPublisher<Discardable, Error>
    func updateRestaurantEmail(with updateEmailRequestDTO: UpdateEmailRequestDTO) -> AnyPublisher<Discardable, Error>
    func delete() -> AnyPublisher<Discardable, Error>
}

class RestaurantsRemoteRepository: RestaurantsRemoteRepositing {
    @Injected private var networkClient: Networking
    
    func getRestaurants(with searchRequestDTO: SearchRequestDTO?) -> AnyPublisher<RestaurantListResponseDTO, Error> {
        networkClient.request(endpoint: Endpoint.restaurants(searchRequestDTO))
    }
    
    func getRestaurantProfile() -> AnyPublisher<RestaurantResponseDTO, Error> {
        networkClient.request(endpoint: Endpoint.restaurantProfile)
    }
    
    func uploadImage(with parameters: [String: String], and dataParameters: DataParameters) -> AnyPublisher<Discardable, Error> {
        networkClient.upload(to: Endpoint.upload, with: parameters, and: dataParameters)
    }
    
    func updateRestaurantProfile(with restaurantUpdateProfileRequestDTO: RestaurantUpdateProfileRequestDTO) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.updateRestaurantProfile(restaurantUpdateProfileRequestDTO))
    }
    
    func updateRestaurantPassword(with updatePasswordRequestDTO: UpdatePasswordRequestDTO) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.updateRestaurantPassword(updatePasswordRequestDTO))
    }
    
    func updateRestaurantEmail(with updateEmailRequestDTO: UpdateEmailRequestDTO) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.updateRestaurantEmail(updateEmailRequestDTO))
    }
    
    func delete() -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.delete)
    }
}

// MARK: - Endpoints

extension RestaurantsRemoteRepository {
    enum Endpoint {
        case restaurants(SearchRequestDTO?)
        case restaurantProfile
        case upload
        case updateRestaurantProfile(_: RestaurantUpdateProfileRequestDTO)
        case updateRestaurantPassword(_: UpdatePasswordRequestDTO)
        case updateRestaurantEmail(_: UpdateEmailRequestDTO)
        case delete
    }
}

extension RestaurantsRemoteRepository.Endpoint: APIConfigurable {
    var path: String {
        switch self {
        case .restaurants: return "/restaurants"
        case .restaurantProfile: return "/restaurants/me"
        case .upload: return "/restaurants/me/image"
        case .updateRestaurantProfile: return "/restaurants/me/profile"
        case .updateRestaurantPassword: return "/restaurants/me/password"
        case .updateRestaurantEmail: return "/restaurants/me/email"
        case .delete: return "/restaurants/me"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .restaurants: return .get
        case .restaurantProfile: return .get
        case .upload: return .patch
        case .updateRestaurantProfile: return .patch
        case .updateRestaurantPassword: return .patch
        case .updateRestaurantEmail: return .patch
        case .delete: return .delete
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .restaurants: return nil
        case .restaurantProfile: return nil
        case .upload: return nil
        case .updateRestaurantProfile: return ["Content-Type": "application/json"]
        case .updateRestaurantPassword: return ["Content-Type": "application/json"]
        case .updateRestaurantEmail: return ["Content-Type": "application/json"]
        case .delete: return nil
        }
    }
    
    var queryParameters: Parameters? {
        switch self {
        case .restaurants(let searchRequestDTO): return searchRequestDTO.asDictionary
        default: return nil
        }
    }
    
    func body() throws -> Data? {
        switch self {
        case .restaurants: return nil
        case .restaurantProfile: return nil
        case .upload: return nil
        case .updateRestaurantProfile(let restaurantUpdateProfileRequestDTO): return try restaurantUpdateProfileRequestDTO.asJSON()
        case .updateRestaurantPassword(let updatePasswordRequestDTO): return try updatePasswordRequestDTO.asJSON()
        case .updateRestaurantEmail(let updateEmailRequestDTO): return try updateEmailRequestDTO.asJSON()
        case .delete: return nil
        }
    }
}
