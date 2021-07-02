//
//  NetworkingHelpers.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.06.2021..
//

import Foundation
import Combine

extension Just where Output == Void {
    static func withErrorType<E>(_ errorType: E.Type) -> AnyPublisher<Void, E> {
        return withErrorType((), E.self)
    }
}

extension Just {
    static func withErrorType<E>(_ value: Output, _ errorType: E.Type
    ) -> AnyPublisher<Output, E> {
        return Just(value)
            .setFailureType(to: E.self)
            .eraseToAnyPublisher()
    }
}

extension Publisher {
    func sinkToResult(_ result: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
        return sink { completion in
            switch completion {
            case let .failure(error):
                Swift.print(error)
                return result(.failure(error))
            default: break
            }
        } receiveValue: { value in
            result(.success(value))
        }

    }
    
    func sinkToLoadable(_ completion: @escaping (Loadable<Output>) -> Void) -> AnyCancellable {
        return sink { subscriptionCompletion in
            if let error = subscriptionCompletion.error {
                Swift.print(error)
                completion(.failed(error))
            }
        } receiveValue: { value in
            completion(.loaded(value))
        }

    }
    
    func extractUnderlyingError() -> Publishers.MapError<Self, Failure> {
        mapError {
            ($0.underlyingError as? Failure) ?? $0
        }
    }
}

private extension Error {
    var underlyingError: Error? {
        let nsError = self as NSError
        if nsError.domain == NSURLErrorDomain && nsError.code == -1009 {
            // "The internet connection appears to be offline"
            return self
        }
        return nsError.userInfo[NSUnderlyingErrorKey] as? Error
    }
}

extension Subscribers.Completion {
    var error: Failure? {
        switch self {
        case let .failure(error): return error
        default: return nil
        }
    }
}

extension URLRequest {
    public var curlString: String {
            guard let url = url else { return "" }
        var base = #"curl "\#(url.absoluteString)""#

            if httpMethod == "HEAD" {
                base += " --head"
            }

            var curl = [base]

            if let method = httpMethod, method != "GET" && method != "HEAD" {
                curl.append("-X \(method)")
            }

            if let headers = allHTTPHeaderFields {
                for (key, value) in headers where key != "Cookie" {
                    curl.append("-H '\(key): \(value)'")
                }
            }

            if let data = httpBody, let body = String(data: data, encoding: .utf8) {
                curl.append("-d '\(body)'")
            }

            return curl.joined(separator: " \\\n\t")
        }
}
