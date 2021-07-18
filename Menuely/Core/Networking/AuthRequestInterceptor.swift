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
    @Injected private var appState: Store<AppState>
    @Injected private var authenticator: Authenticating
    @Injected private var secureLocalRepository: SecureLocalRepositing
    
    // MARK: - Properties
    private let cancelBag = CancelBag()
    
    // MARK: - Methods
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        /// Sets the Authorization header value using the access token.
        let authenticatedUser = secureLocalRepository.load(AuthenticatedUser.self, for: .authenticatedUser)
        let authenticatedRestaurant = secureLocalRepository.load(AuthenticatedRestaurant.self, for: .authenticatedRestaurant)
        let tokens = authenticatedUser?.auth ?? authenticatedRestaurant?.auth
        
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
        
        let authenticatedUser = secureLocalRepository.load(AuthenticatedUser.self, for: .authenticatedUser)
        let authenticatedRestaurant = secureLocalRepository.load(AuthenticatedRestaurant.self, for: .authenticatedRestaurant)
        let tokens = authenticatedUser?.auth ?? authenticatedRestaurant?.auth
        
        guard let refreshToken = tokens?.refreshToken else {
            return completion(.doNotRetryWithError(NetworkError.refreshTokenMissing))
        }
        
        authenticator.refreshTokens(with: TokensRequestDTO(refreshToken: refreshToken)).sinkToResult { result in
            switch result {
            case .success(let tokensResponseDTO):
                
                if var authenticatedUser = self.secureLocalRepository.load(AuthenticatedUser.self, for: .authenticatedUser) {
                    
                    authenticatedUser.auth = tokensResponseDTO.tokens
                    self.secureLocalRepository.save(authenticatedUser, for: .authenticatedUser)
                    self.appState[\.data.authenticatedUser] = authenticatedUser
                    
                } else if var authenticatedRestaurant = self.secureLocalRepository.load(AuthenticatedRestaurant.self, for: .authenticatedRestaurant) {
                    
                    authenticatedRestaurant.auth = tokensResponseDTO.tokens
                    self.secureLocalRepository.save(authenticatedRestaurant, for: .authenticatedRestaurant)
                    self.appState[\.data.authenticatedRestaurant] = authenticatedRestaurant
                    
                }

                // Print CURL for retried request
                print(request.cURLDescription())
                
                completion(.retry)
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }.store(in: cancelBag)
    }
}
