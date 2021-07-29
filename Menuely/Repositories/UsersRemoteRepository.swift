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
    func updateUserProfile(with updateUserProfileRequestDTO: UpdateUserProfileRequestDTO) -> AnyPublisher<Discardable, Error>
    func updateUserPassword(with updatePasswordRequestDTO: UpdatePasswordRequestDTO) -> AnyPublisher<Discardable, Error>
    func updateUserEmail(with updateEmailRequestDTO: UpdateEmailRequestDTO) -> AnyPublisher<Discardable, Error>
    func delete() -> AnyPublisher<Discardable, Error>
}

class UsersRemoteRepository: UsersRemoteRepositing {
    @Injected private var networkClient: Networking
    @Injected private var multipartFormatter: MultipartFormatter
    
    func getUsers() -> AnyPublisher<UsersListResponseDTO, Error> {
        networkClient.request(endpoint: Endpoint.users)
    }
    
    func getUserProfile() -> AnyPublisher<UserResponseDTO, Error> {
        networkClient.request(endpoint: Endpoint.userProfile)
    }
    
    func uploadImage(with multipartFormDataRequestable: MultipartFormDataRequestable) -> AnyPublisher<Discardable, Error> {
        
        guard let multipartFormData = multipartFormatter.format(multipartFormDataRequestable) else {
            return Fail(error: DataError.malformed as Error).eraseToAnyPublisher()
        }
        
        return networkClient.request(endpoint: Endpoint.upload(multipartFormData))
    }
    
    func updateUserProfile(with updateUserProfileRequestDTO: UpdateUserProfileRequestDTO) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.updateUserProfile(updateUserProfileRequestDTO))
    }
    
    func updateUserPassword(with updatePasswordRequestDTO: UpdatePasswordRequestDTO) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.updateUserPassword(updatePasswordRequestDTO))
    }
    
    func updateUserEmail(with updateEmailRequestDTO: UpdateEmailRequestDTO) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.updateUserEmail(updateEmailRequestDTO))
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
        case upload(_: MultipartFormData)
        case updateUserProfile(_: UpdateUserProfileRequestDTO)
        case updateUserPassword(_: UpdatePasswordRequestDTO)
        case updateUserEmail(_: UpdateEmailRequestDTO)
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
        case .upload(let multipartFormData): return ["Content-Type": "multipart/form-data; boundary=\(multipartFormData.boundary)"]
        case .updateUserProfile: return ["Content-Type": "application/json"]
        case .updateUserPassword: return ["Content-Type": "application/json"]
        case .updateUserEmail: return ["Content-Type": "application/json"]
        case .delete: return nil
        }
    }
    
    var query: QueryRequestable? {
        return nil
    }
    
    func body() throws -> Data? {
        switch self {
        case .users: return nil
        case .userProfile: return nil
        case .upload(let multipartFormData): return try multipartFormData.encode()
        case .updateUserProfile(let updateUserProfileRequestDTO): return try updateUserProfileRequestDTO.asJSON()
        case .updateUserPassword(let updatePasswordRequestDTO): return try updatePasswordRequestDTO.asJSON()
        case .updateUserEmail(let updateEmailRequestDTO): return try updateEmailRequestDTO.asJSON()
        case .delete: return nil
        }
    }
}
