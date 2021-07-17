//
//  AuthRequestInterceptor.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 06.07.2021..
//

import Foundation
import Alamofire
import Resolver
import Combine

class AuthRequestInterceptor: RequestInterceptor {
    
    // MARK: - Property Wrappers
    @Injected private var authenticator: Authenticating
    @Injected private var keychainRepository: KeychainRepositing
    
    // MARK: - Properties
    private let cancelBag = CancelBag()
    
    // MARK: - Methods
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        /// Sets the Authorization header value using the access token.
        let tokens: Tokens? = keychainRepository.loadData(for: .tokens)
        if let accessToken = tokens?.accessToken {
            urlRequest.headers.add(.authorization(bearerToken: accessToken))
        }
        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            /// The request did not fail due to a 401 Unauthorized response.
            /// Return the original error and don't retry the request.
            return completion(.doNotRetryWithError(error))
        }
        
        let tokens: Tokens? = keychainRepository.loadData(for: .tokens)
        guard let refreshToken = tokens?.refreshToken else {
            return completion(.doNotRetryWithError(NetworkError.refreshTokenMissing))
        }
        
        authenticator.refreshTokens(with: TokensRequestDTO(refreshToken: refreshToken)).sinkToResult { result in
            switch result {
            case .success(let tokensResponseDTO):
                
                self.keychainRepository.saveData(tokensResponseDTO.tokens, to: .tokens)
                
                // Print CURL for retried request
                print(request.cURLDescription())
                
                completion(.retry)
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }.store(in: cancelBag)
    }
}
