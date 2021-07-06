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
    func getUsers() -> AnyPublisher<Users, Error>
}

class UsersRemoteRepository: UsersRemoteRepositing {
    
    @Injected private var networkClient: Networking
    
    func getUsers() -> AnyPublisher<Users, Error> {
        networkClient.request(endpoint: Endpoint.users)
    }
}

// MARK: - Endpoints

extension UsersRemoteRepository {
    enum Endpoint {
        case users
    }
}

extension UsersRemoteRepository.Endpoint: APIConfigurable {
    var path: String {
        switch self {
        case .users: return "/users"
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .users: return .get
        }
    }
    
    var headers: [String : String]? {
        return ["Accept": "application/json"]
    }
    
    var queryParameters: Parameters? {
        return nil
    }
    
    var bodyParameters: Parameters? {
        return nil
    }
}
