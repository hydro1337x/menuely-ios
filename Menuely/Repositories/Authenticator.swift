//
//  AuthRemoteRepository.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 06.07.2021..
//

import Foundation
import Resolver
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
        session.request(Endpoint.refresh(tokensRequestDTO: tokensRequestDTO))
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
        case refresh(tokensRequestDTO: TokensRequestDTO)
    }
}

extension Authenticator.Endpoint: APIConfigurable {
    var path: String {
        return "/auth/refreshToken"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var queryParameters: Parameters? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .refresh(let tokensRequestDTO):
            return tokensRequestDTO.asJSON()
        }
    }
}
