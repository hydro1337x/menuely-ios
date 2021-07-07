//
//  AuthRemoteRepository.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 06.07.2021..
//

import Foundation
import Combine
import Alamofire

protocol Authenticating {
    func refreshTokens(with tokensRequestDTO: TokensRequestDTO) -> AnyPublisher<Tokens, Error>
}

class Authenticator: Authenticating {
    private var session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func refreshTokens(with tokensRequestDTO: TokensRequestDTO) -> AnyPublisher<Tokens, Error> {
        session.request(Endpoint.refresh(tokensRequestDTO))
            .cURLDescription(calling: { curl in
                print(curl)
            })
            .publishDecodable(type: Tokens.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

extension Authenticator {
    enum Endpoint {
        case refresh(TokensRequestDTO)
    }
}

extension Authenticator.Endpoint: APIConfigurable {
    var path: String {
        return "/auth/refresh-token"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var queryParameters: Parameters? {
        return nil
    }
    
    func body() throws -> Data? {
        switch self {
        case .refresh(let tokensRequestDTO): return try tokensRequestDTO.asJSON()
        }
    }
}
