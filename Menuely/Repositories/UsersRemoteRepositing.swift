//
//  UsersRemoteRepository.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.07.2021..
//

import Foundation
import Combine

protocol UsersRemoteRepositing: RemoteRepositing {
    func getUsers() -> AnyPublisher<Users, Error>
}

struct UsersRemoteRepository: UsersRemoteRepositing {
    func getUsers() -> AnyPublisher<Users, Error> {
        call(endpoint: Endpoint.users)
    }
    
    var session: URLSession
    
    var baseURL: String
    
    var backgroundQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
}

// MARK: - Endpoints

extension UsersRemoteRepository {
    enum Endpoint {
        case users
    }
}

extension UsersRemoteRepository.Endpoint: Networking {
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
    
    func body() throws -> Data? {
        return nil
    }
    
    
}
