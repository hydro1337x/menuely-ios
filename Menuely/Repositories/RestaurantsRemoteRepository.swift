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
    func getRestaurants(with query: SearchQueryRequest?) -> AnyPublisher<RestaurantsListResponseDTO, Error>
    func getRestaurantProfile() -> AnyPublisher<RestaurantResponseDTO, Error>
    func uploadImage(with multipartFormDataRequestable: MultipartFormDataRequestable) -> AnyPublisher<Discardable, Error>
    func updateRestaurantProfile(with updateRestaurantProfileRequestDTO: UpdateRestaurantProfileRequestDTO) -> AnyPublisher<Discardable, Error>
    func updateRestaurantPassword(with updatePasswordRequestDTO: UpdatePasswordRequestDTO) -> AnyPublisher<Discardable, Error>
    func updateRestaurantEmail(with updateEmailRequestDTO: UpdateEmailRequestDTO) -> AnyPublisher<Discardable, Error>
    func delete() -> AnyPublisher<Discardable, Error>
}

class RestaurantsRemoteRepository: RestaurantsRemoteRepositing {
    @Injected private var networkClient: Networking
    @Injected private var multipartFormatter: MultipartFormatter
    
    func getRestaurants(with query: SearchQueryRequest?) -> AnyPublisher<RestaurantsListResponseDTO, Error> {
        networkClient.request(endpoint: Endpoint.restaurants(query))
    }
    
    func getRestaurantProfile() -> AnyPublisher<RestaurantResponseDTO, Error> {
        networkClient.request(endpoint: Endpoint.restaurantProfile)
    }
    
    func uploadImage(with multipartFormDataRequestable: MultipartFormDataRequestable) -> AnyPublisher<Discardable, Error> {
        guard let multipartFormData = multipartFormatter.format(multipartFormDataRequestable) else {
            return Fail(error: DataError.malformed as Error).eraseToAnyPublisher()
        }
        
        return networkClient.request(endpoint: Endpoint.upload(multipartFormData))
    }
    
    func updateRestaurantProfile(with updateRestaurantProfileRequestDTO: UpdateRestaurantProfileRequestDTO) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.updateRestaurantProfile(updateRestaurantProfileRequestDTO))
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
        case restaurants(SearchQueryRequest?)
        case restaurantProfile
        case upload(_: MultipartFormData)
        case updateRestaurantProfile(_: UpdateRestaurantProfileRequestDTO)
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
        case .upload(let multipartFormData): return ["Content-Type": "multipart/form-data; boundary=\(multipartFormData.boundary)"]
        case .updateRestaurantProfile: return ["Content-Type": "application/json"]
        case .updateRestaurantPassword: return ["Content-Type": "application/json"]
        case .updateRestaurantEmail: return ["Content-Type": "application/json"]
        case .delete: return nil
        }
    }
    
    var query: QueryRequestable? {
        switch self {
        case .restaurants(let query): return query
        default: return nil
        }
    }
    
    func body() throws -> Data? {
        switch self {
        case .restaurants: return nil
        case .restaurantProfile: return nil
        case .upload(let multipartFormData): return try multipartFormData.encode()
        case .updateRestaurantProfile(let updateRestaurantProfileRequestDTO): return try updateRestaurantProfileRequestDTO.asJSON()
        case .updateRestaurantPassword(let updatePasswordRequestDTO): return try updatePasswordRequestDTO.asJSON()
        case .updateRestaurantEmail(let updateEmailRequestDTO): return try updateEmailRequestDTO.asJSON()
        case .delete: return nil
        }
    }
}
