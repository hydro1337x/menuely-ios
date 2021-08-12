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
    func getUserOrders() -> AnyPublisher<OrdersListResponse, Error>
}

class OrdersRemoteRepository: OrdersRemoteRepositing {
    @Injected private var networkClient: Networking
    
    func createOrder(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.createOrder(bodyRequest))
    }
    
    func getUserOrders() -> AnyPublisher<OrdersListResponse, Error> {
        networkClient.request(endpoint: Endpoint.getUserOrders)
    }
}

// MARK: - Endpoints

extension OrdersRemoteRepository {
    enum Endpoint {
        case createOrder(BodyRequestable)
        case getUserOrders
    }
}

extension OrdersRemoteRepository.Endpoint: APIConfigurable {
    var path: String {
        switch self {
        case .createOrder: return "/orders/create"
        case .getUserOrders: return "/orders/user"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createOrder: return .post
        case .getUserOrders: return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .createOrder: return ["Content-Type": "application/json"]
        case .getUserOrders: return ["Content-Type": "application/json"]
        }
    }
    
    var queryRequestable: QueryRequestable? {
        switch self {
        case .createOrder: return nil
        case .getUserOrders: return nil
        }
    }
    
    var bodyRequestable: BodyRequestable? {
        switch self {
        case .createOrder(let bodyRequest): return bodyRequest
        case .getUserOrders: return nil
        }
    }
    
    var multipartFormDataRequestable: MultipartFormDataRequestable? {
        return nil
    }
}
