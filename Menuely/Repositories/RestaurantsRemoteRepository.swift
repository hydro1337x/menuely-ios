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

        return networkClient.upload(to: Endpoint.upload, with: parameters, and: dataParameters)
    }
}

// MARK: - Endpoints

extension RestaurantsRemoteRepository {
    enum Endpoint {
        case restaurants
        case restaurantProfile
        case upload
    }
}

extension RestaurantsRemoteRepository.Endpoint: APIConfigurable {
    var path: String {
        switch self {
        case .restaurants: return "/restaurants"
        case .restaurantProfile: return "/restaurants/me"
        case .upload: return "/restaurants/me/image"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .restaurants: return .get
        case .restaurantProfile: return .get
        case .upload: return .patch
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .restaurants: return nil
        case .restaurantProfile: return nil
        case .upload: return nil
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
        }
    }
}
