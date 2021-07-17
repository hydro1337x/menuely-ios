//
//  NetworkClient.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 05.07.2021..
//

import Foundation
import Alamofire
import Combine
import UIKit

protocol Networking {
    func request<Value>(endpoint: URLRequestConvertible) -> AnyPublisher<Value, Error> where Value: Decodable
    func upload<Value>(to endpoint: URLRequestConvertible, with parameters: [String: String], and dataParameters: DataParameters) -> AnyPublisher<Value, Error> where Value: Decodable
}

class NetworkClient: Networking {
    private let session: Session
    private let interceptor: RequestInterceptor
    
    init(session: Session, interceptor: RequestInterceptor) {
        self.session = session
        self.interceptor = interceptor
    }
    
    func request<Value>(endpoint: URLRequestConvertible) -> AnyPublisher<Value, Error> where Value: Decodable {
        session.request(endpoint, interceptor: interceptor)
            .cURLDescription(calling: { curl in
                print(curl)
            })
            .validate()
            .publishDecodable(type: Value.self)
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
            .decode(type: Value.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { decodable in
                print("Response: ", decodable)
            })
            .eraseToAnyPublisher()
        
    }
    
    func upload<Value>(to endpoint: URLRequestConvertible, with parameters: [String: String], and dataParameters: DataParameters) -> AnyPublisher<Value, Error> where Value: Decodable {
        session.upload(multipartFormData: { multipartFormData in
            for (fieldName, value) in parameters {
                multipartFormData.append(value.data(using: .utf8)!, withName: fieldName)
            }
            
            for (fieldName, value) in dataParameters {
                multipartFormData.append(value.file, withName: fieldName, fileName: value.fileName, mimeType: value.mimeType.rawValue)
            }
        }, with: endpoint, interceptor: interceptor)
        .cURLDescription { curl in
            print("Upload curl: ", curl)
        }
        .validate()
        .publishDecodable(type: Value.self)
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
        .decode(type: Value.self, decoder: JSONDecoder())
        .handleEvents(receiveOutput: { decodable in
            print("Response: ", decodable)
        })
        .eraseToAnyPublisher()
    }
}
