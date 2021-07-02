//
//  RemoteRepository.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.06.2021..
//

import Foundation
import Combine

protocol RemoteRepositing {
    var session: URLSession { get }
    var baseURL: String { get }
    var backgroundQueue: DispatchQueue { get }
}

extension RemoteRepositing {
    func call<Value>(endpoint: Networking, httpCodes: HTTPCodes = .success) -> AnyPublisher<Value, Error> where Value: Decodable {
        do {
            let request = try endpoint.urlRequest(baseURL: baseURL)
            return session
                    .dataTaskPublisher(for: request)
                    .requestJSON(httpCodes: httpCodes)
        } catch let error {
            return Fail<Value, Error>(error: error).eraseToAnyPublisher()
        }
    }
}

// MARK: - Helpers
private extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func requestJSON<Value>(httpCodes: HTTPCodes) -> AnyPublisher<Value, Error> where Value: Decodable {
        return tryMap { data, response in
            assert(!Thread.isMainThread)
            guard let code = (response as? HTTPURLResponse)?.statusCode else { throw NetworkError.unexpectedResponse }
            guard httpCodes.contains(code) else { throw NetworkError.httpCode(code) }
            return data
        }
        .extractUnderlyingError()
        .decode(type: Value.self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
        
    }
}
