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
    func getUserOrder(with id: PathParameter) -> AnyPublisher<OrderResponse, Error>
    func getUserOrders() -> AnyPublisher<OrdersListResponse, Error>
}

class OrdersRemoteRepository: OrdersRemoteRepositing {
    @Injected private var networkClient: Networking
    
    func createOrder(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.createOrder(bodyRequest))
    }
    
    func getUserOrder(with id: PathParameter) -> AnyPublisher<OrderResponse, Error> {
        networkClient.request(endpoint: Endpoint.getUserOrder(id))
    }
    
    func getUserOrders() -> AnyPublisher<OrdersListResponse, Error> {
        networkClient.request(endpoint: Endpoint.getUserOrders)
    }
}

// MARK: - Endpoints

extension OrdersRemoteRepository {
    enum Endpoint {
        case createOrder(BodyRequestable)
        case getUserOrder(PathParameter)
        case getUserOrders
    }
}

extension OrdersRemoteRepository.Endpoint: APIConfigurable {
    var path: String {
        switch self {
        case .createOrder: return "/orders/create"
        case .getUserOrder(let id): return "/orders/\(id)/user"
        case .getUserOrders: return "/orders/user"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createOrder: return .post
        case .getUserOrder: return .get
        case .getUserOrders: return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .createOrder: return ["Content-Type": "application/json"]
        case .getUserOrder: return ["Content-Type": "application/json"]
        case .getUserOrders: return ["Content-Type": "application/json"]
        }
    }
    
    var queryRequestable: QueryRequestable? {
        switch self {
        case .createOrder: return nil
        case .getUserOrder: return nil
        case .getUserOrders: return nil
        }
    }
    
    var bodyRequestable: BodyRequestable? {
        switch self {
        case .createOrder(let bodyRequest): return bodyRequest
        case .getUserOrder: return nil
        case .getUserOrders: return nil
        }
    }
    
    var multipartFormDataRequestable: MultipartFormDataRequestable? {
        return nil
    }
}
