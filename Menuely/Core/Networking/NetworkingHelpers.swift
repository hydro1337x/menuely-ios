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
}

extension Subscribers.Completion {
    var error: Failure? {
        switch self {
        case let .failure(error): return error
        default: return nil
        }
    }
}
