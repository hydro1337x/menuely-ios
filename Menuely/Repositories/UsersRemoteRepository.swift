//
//  UsersRemoteRepository.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.07.2021..
//

import Foundation
import Resolver
import Combine
import UIKit

protocol UsersRemoteRepositing {
    func getUsers() -> AnyPublisher<UserListResponseDTO, Error>
    func getUserProfile() -> AnyPublisher<UserResponseDTO, Error>
    func uploadImage(with parameters: [String: String], and dataParameters: DataParameters) -> AnyPublisher<Discardable, Error>
}

class UsersRemoteRepository: UsersRemoteRepositing {
    @Injected private var networkClient: Networking
    
    func getUsers() -> AnyPublisher<UserListResponseDTO, Error> {
        networkClient.request(endpoint: Endpoint.users)
    }
    
    func getUserProfile() -> AnyPublisher<UserResponseDTO, Error> {
        networkClient.request(endpoint: Endpoint.userProfile)
    }
    
    func uploadImage(with parameters: [String: String], and dataParameters: DataParameters) -> AnyPublisher<Discardable, Error> {

        return networkClient.upload(to: Endpoint.upload, with: parameters, and: dataParameters)
    }
}

// MARK: - Endpoints

extension UsersRemoteRepository {
    enum Endpoint {
        case users
        case userProfile
        case upload
    }
}

extension UsersRemoteRepository.Endpoint: APIConfigurable {
    var path: String {
        switch self {
        case .users: return "/users"
        case .userProfile: return "/users/me"
        case .upload: return "/users/me/image"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .users: return .get
        case .userProfile: return .get
        case .upload: return .patch
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .users: return nil
        case .userProfile: return nil
        case .upload: return nil
        }
    }
    
    var queryParameters: Parameters? {
        return nil
    }
    
    func body() throws -> Data? {
        switch self {
        case .users: return nil
        case .userProfile: return nil
        case .upload: return nil
        }
    }
}
