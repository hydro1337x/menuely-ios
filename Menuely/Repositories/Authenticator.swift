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
    func refreshTokens(with tokensRequestDTO: TokensRequestDTO) -> AnyPublisher<TokensResponseDTO, Error>
}

class Authenticator: Authenticating {
    private var session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func refreshTokens(with tokensRequestDTO: TokensRequestDTO) -> AnyPublisher<TokensResponseDTO, Error> {
        session.request(Endpoint.refresh(tokensRequestDTO))
            .cURLDescription(calling: { curl in
                print(curl)
            })
            .publishDecodable(type: TokensResponseDTO.self)
            .tryMap {
                guard let code = $0.response?.statusCode else {
                    throw NetworkError.unexpectedResponse
                }
                guard HTTPCodes.success.contains(code) else {
                    throw NetworkError.httpCode(code)
                }
                guard let data = $0.data else {
                    throw DataError.missing
                }
                return data
            }
            .decode(type: TokensResponseDTO.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { tokens in
                print("Response: ", tokens)
            })
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
