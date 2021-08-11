//
//  OrdersRemoteRepository.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 11.08.2021..
//

import Foundation
import Resolver
import Combine
import Alamofire

protocol OrdersRemoteRepositing {
    func createOrder(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error>
}

class OrdersRemoteRepository: OrdersRemoteRepositing {
    @Injected private var networkClient: Networking
    
    func createOrder(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.createOrder(bodyRequest))
    }
}

// MARK: - Endpoints

extension OrdersRemoteRepository {
    enum Endpoint {
        case createOrder(BodyRequestable)
    }
}

extension OrdersRemoteRepository.Endpoint: APIConfigurable {
    var path: String {
        switch self {
        case .createOrder: return "/orders/create"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createOrder: return .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .createOrder: return ["Content-Type": "application/json"]
        }
    }
    
    var queryRequestable: QueryRequestable? {
        switch self {
        case .createOrder: return nil
        }
    }
    
    var bodyRequestable: BodyRequestable? {
        switch self {
        case .createOrder(let bodyRequest): return bodyRequest
        }
    }
    
    var multipartFormDataRequestable: MultipartFormDataRequestable? {
        return nil
    }
}
