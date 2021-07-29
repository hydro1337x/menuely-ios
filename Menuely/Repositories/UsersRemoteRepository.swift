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
import Alamofire

protocol UsersRemoteRepositing {
    func getUsers() -> AnyPublisher<UsersListResponseDTO, Error>
    func getUserProfile() -> AnyPublisher<UserResponseDTO, Error>
    func uploadImage(with multipartFormDataRequestable: MultipartFormDataRequestable) -> AnyPublisher<Discardable, Error>
    func updateUserProfile(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error>
    func updateUserPassword(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error>
    func updateUserEmail(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error>
    func delete() -> AnyPublisher<Discardable, Error>
}

class UsersRemoteRepository: UsersRemoteRepositing {
    @Injected private var networkClient: Networking
    
    func getUsers() -> AnyPublisher<UsersListResponseDTO, Error> {
        networkClient.request(endpoint: Endpoint.users)
    }
    
    func getUserProfile() -> AnyPublisher<UserResponseDTO, Error> {
        networkClient.request(endpoint: Endpoint.userProfile)
    }
    
    func uploadImage(with multipartFormDataRequestable: MultipartFormDataRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.upload(multipartFormDataRequestable))
    }
    
    func updateUserProfile(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.updateUserProfile(bodyRequest))
    }
    
    func updateUserPassword(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.updateUserPassword(bodyRequest))
    }
    
    func updateUserEmail(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.updateUserEmail(bodyRequest))
    }
    
    func delete() -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.delete)
    }
}

// MARK: - Endpoints

extension UsersRemoteRepository {
    enum Endpoint {
        case users
        case userProfile
        case upload(_: MultipartFormDataRequestable)
        case updateUserProfile(_: BodyRequestable)
        case updateUserPassword(_: BodyRequestable)
        case updateUserEmail(_: BodyRequestable)
        case delete
    }
}

extension UsersRemoteRepository.Endpoint: APIConfigurable {
    var path: String {
        switch self {
        case .users: return "/users"
        case .userProfile: return "/users/me"
        case .upload: return "/users/me/image"
        case .updateUserProfile: return "/users/me/profile"
        case .updateUserPassword: return "/users/me/password"
        case .updateUserEmail: return "/users/me/email"
        case .delete: return "/users/me"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .users: return .get
        case .userProfile: return .get
        case .upload: return .patch
        case .updateUserProfile: return .patch
        case .updateUserPassword: return .patch
        case .updateUserEmail: return .patch
        case .delete: return .delete
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .users: return nil
        case .userProfile: return nil
        case .upload: return nil
        case .updateUserProfile: return ["Content-Type": "application/json"]
        case .updateUserPassword: return ["Content-Type": "application/json"]
        case .updateUserEmail: return ["Content-Type": "application/json"]
        case .delete: return nil
        }
    }
    
    var queryRequestable: QueryRequestable? {
        return nil
    }
    
    var bodyRequestable: BodyRequestable? {
        switch self {
        case .users: return nil
        case .userProfile: return nil
        case .upload: return nil
        case .updateUserProfile(let bodyRequest): return bodyRequest
        case .updateUserPassword(let bodyRequest): return bodyRequest
        case .updateUserEmail(let bodyRequest): return bodyRequest
        case .delete: return nil
        }
    }
    
    var multipartFormDataRequestable: MultipartFormDataRequestable? {
        switch self {
        case .upload(let multipartFormDataRequestable): return multipartFormDataRequestable
        default: return nil
        }
    }
}
