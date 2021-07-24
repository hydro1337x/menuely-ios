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
    func getRestaurants() -> AnyPublisher<RestaurantListResponseDTO, Error>
    func getRestaurantProfile() -> AnyPublisher<RestaurantResponseDTO, Error>
    func uploadImage(with parameters: [String: String], and dataParameters: DataParameters) -> AnyPublisher<Discardable, Error>
    func updateRestaurantProfile(with restaurantUpdateProfileRequestDTO: RestaurantUpdateProfileRequestDTO) -> AnyPublisher<Discardable, Error>
    func updateRestaurantPassword(with updatePasswordRequestDTO: UpdatePasswordRequestDTO) -> AnyPublisher<Discardable, Error>
}

class RestaurantsRemoteRepository: RestaurantsRemoteRepositing {
    @Injected private var networkClient: Networking
    
    func getRestaurants() -> AnyPublisher<RestaurantListResponseDTO, Error> {
        networkClient.request(endpoint: Endpoint.restaurants)
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
}

// MARK: - Endpoints

extension RestaurantsRemoteRepository {
    enum Endpoint {
        case restaurants
        case restaurantProfile
        case upload
        case updateRestaurantProfile(_: RestaurantUpdateProfileRequestDTO)
        case updateRestaurantPassword(_: UpdatePasswordRequestDTO)
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
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .restaurants: return .get
        case .restaurantProfile: return .get
        case .upload: return .patch
        case .updateRestaurantProfile: return .patch
        case .updateRestaurantPassword: return .patch
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .restaurants: return nil
        case .restaurantProfile: return nil
        case .upload: return nil
        case .updateRestaurantProfile: return ["Content-Type": "application/json"]
        case .updateRestaurantPassword: return ["Content-Type": "application/json"]
        }
    }
    
    var queryParameters: Parameters? {
        return nil
    }
    
    func body() throws -> Data? {
        switch self {
        case .restaurants: return nil
        case .restaurantProfile: return nil
        case .upload: return nil
        case .updateRestaurantProfile(let restaurantUpdateProfileRequestDTO): return try restaurantUpdateProfileRequestDTO.asJSON()
        case .updateRestaurantPassword(let updatePasswordRequestDTO): return try updatePasswordRequestDTO.asJSON()
        }
    }
}
