//
//  UsersRemoteRepository.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.07.2021..
//

import Foundation
import Resolver
import Combine

protocol UsersRemoteRepositing {
    func getUsers() -> AnyPublisher<UserListResponseDTO, Error>
    func refreshTokens() -> AnyPublisher<TokensResponseDTO, Error>
}

class UsersRemoteRepository: UsersRemoteRepositing {
    @Injected private var networkClient: Networking
    
    func getUsers() -> AnyPublisher<UserListResponseDTO, Error> {
        networkClient.request(endpoint: Endpoint.users)
    }
    
    func refreshTokens() -> AnyPublisher<TokensResponseDTO, Error> {
        networkClient.request(endpoint: Endpoint.refreshTokens)
    }
}

// MARK: - Endpoints

extension UsersRemoteRepository {
    enum Endpoint {
        case users
        case refreshTokens
    }
}

extension UsersRemoteRepository.Endpoint: APIConfigurable {
    var path: String {
        switch self {
        case .users: return "/users"
        case .refreshTokens: return "/auth/refresh-token"
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .users: return .get
        case .refreshTokens: return .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .users: return nil
        case .refreshTokens: return ["Content-Type": "application/json"]
        }
    }
    
    var queryParameters: Parameters? {
        return nil
    }
    
    func body() throws -> Data? {
        switch self {
        case .users: return nil
        case .refreshTokens: return try TokensRequestDTO(refreshToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTksImlhdCI6MTYyNTY4NDE3NiwiZXhwIjoxNjU3MjIwMTc2fQ.DJW7FG_7fwOIo4TWv9DnGrL3cSjqyMb7AGAYPPFLV1I").asJSON()
        }
    }
}
