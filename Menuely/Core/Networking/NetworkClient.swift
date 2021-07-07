//
//  NetworkClient.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 05.07.2021..
//

import Foundation
import Alamofire
import Combine

protocol Networking {
    func request<Value>(endpoint: URLRequestConvertible) -> AnyPublisher<Value, Error> where Value: Decodable
}

class NetworkClient: Networking {
    private let session: Session
    private let interceptor: RequestInterceptor
    
    init(session: Session, interceptor: RequestInterceptor) {
        self.session = session
        self.interceptor = interceptor
    }
    
    func request<Value>(endpoint: URLRequestConvertible) -> AnyPublisher<Value, Error> where Value : Decodable {
        session.request(endpoint, interceptor: interceptor)
            .cURLDescription(calling: { curl in
                print(curl)
            })
            .validate()
            .publishDecodable(type: Value.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
        
    }
}
