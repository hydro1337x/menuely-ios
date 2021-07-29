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
    func refreshTokens(with bodyRequest: BodyRequestable) -> AnyPublisher<TokensResponse, Error>
}

class Authenticator: Authenticating {
    private var session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func refreshTokens(with bodyRequest: BodyRequestable) -> AnyPublisher<TokensResponse, Error> {
        session.request(Endpoint.refresh(bodyRequest))
            .cURLDescription(calling: { curl in
                print(curl)
            })
            .publishDecodable(type: TokensResponse.self)
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
            .decode(type: TokensResponse.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { tokens in
                print("Response: ", tokens)
            })
            .eraseToAnyPublisher()
    }
}

extension Authenticator {
    enum Endpoint {
        case refresh(BodyRequestable)
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
    
    var queryRequestable: QueryRequestable? {
        return nil
    }
    
    var bodyRequestable: BodyRequestable? {
        switch self {
        case .refresh(let bodyRequest): return bodyRequest
        }
    }
    
    var multipartFormDataRequestable: MultipartFormDataRequestable? {
        return nil
    }
}
