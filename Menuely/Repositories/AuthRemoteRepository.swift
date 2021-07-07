//
//  AuthRemoteRepository.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 07.07.2021..
//

import Foundation
import Combine
import Resolver

protocol AuthRemoteRepositing {
    func registerUser(userRegistrationRequestDTO: UserRegistrationRequestDTO) -> AnyPublisher<Discardable, Error>
    func loginUser(userLoginRequestDTO: UserLoginRequestDTO) -> AnyPublisher<UserLoginResponseDTO, Error>
}

class AuthRemoteRepository: AuthRemoteRepositing {
    @Injected private var networkClient: Networking
    
    func registerUser(userRegistrationRequestDTO: UserRegistrationRequestDTO) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.registerUser(userRegistrationRequestDTO))
    }

    func loginUser(userLoginRequestDTO: UserLoginRequestDTO) -> AnyPublisher<UserLoginResponseDTO, Error> {
        networkClient.request(endpoint: Endpoint.loginUser(userLoginRequestDTO))
    }
}

extension AuthRemoteRepository {
    enum Endpoint {
        case registerUser(_: UserRegistrationRequestDTO)
        case loginUser(_: UserLoginRequestDTO)
    }
}

extension AuthRemoteRepository.Endpoint: APIConfigurable {
    var path: String {
        switch self {
        case .registerUser(_): return "/auth/register/user"
        case .loginUser(_): return "/auth/login/user"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .registerUser(_): return .post
        case .loginUser(_): return .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .registerUser(_), .loginUser(_): return ["Content-Type": "application/json"]
        }
    }
    
    var queryParameters: Parameters? {
        return nil
    }
    
    func body() throws -> Data? {
        switch self {
        case .registerUser(let userRegistrationRequestDTO): return try userRegistrationRequestDTO.asJSON()
        case .loginUser(let userLoginRequestDTO): return try userLoginRequestDTO.asJSON()
        }
    }
}
