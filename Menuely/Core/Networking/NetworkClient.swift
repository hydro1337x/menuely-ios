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
    var session: Session { get }
    
    func request<Value>(endpoint: URLRequestConvertible) -> AnyPublisher<Value, Error> where Value: Decodable
}

class NetworkClient: Networking {
    internal var session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func request<Value>(endpoint: URLRequestConvertible) -> AnyPublisher<Value, Error> where Value : Decodable {
        session.request(endpoint)
            .cURLDescription(calling: { curl in
                print("CURL: ", curl)
            })
            .publishDecodable(type: Value.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
        
    }
}
