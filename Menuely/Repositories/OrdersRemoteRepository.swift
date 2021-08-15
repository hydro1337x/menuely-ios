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
    func acceptOrder(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error>
    func getUserOrder(with id: PathParameter) -> AnyPublisher<OrderResponse, Error>
    func getUserOrders() -> AnyPublisher<OrdersListResponse, Error>
    func getRestaurantOrder(with id: PathParameter) -> AnyPublisher<OrderResponse, Error>
    func getRestaurantOrders() -> AnyPublisher<OrdersListResponse, Error>
    
}

class OrdersRemoteRepository: OrdersRemoteRepositing {
    @Injected private var networkClient: Networking
    
    func createOrder(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.createOrder(bodyRequest))
    }
    
    func acceptOrder(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.acceptOrder(bodyRequest))
    }
    
    func getUserOrder(with id: PathParameter) -> AnyPublisher<OrderResponse, Error> {
        networkClient.request(endpoint: Endpoint.getUserOrder(id))
    }
    
    func getUserOrders() -> AnyPublisher<OrdersListResponse, Error> {
        networkClient.request(endpoint: Endpoint.getUserOrders)
    }
    
    func getRestaurantOrder(with id: PathParameter) -> AnyPublisher<OrderResponse, Error> {
        networkClient.request(endpoint: Endpoint.getRestaurantOrder(id))
    }
    
    func getRestaurantOrders() -> AnyPublisher<OrdersListResponse, Error> {
        networkClient.request(endpoint: Endpoint.getRestaurantOrders)
    }
}

// MARK: - Endpoints

extension OrdersRemoteRepository {
    enum Endpoint {
        case createOrder(BodyRequestable)
        case acceptOrder(BodyRequestable)
        case getUserOrder(PathParameter)
        case getUserOrders
        case getRestaurantOrder(PathParameter)
        case getRestaurantOrders
    }
}

extension OrdersRemoteRepository.Endpoint: APIConfigurable {
    var path: String {
        switch self {
        case .createOrder: return "/orders/create"
        case .acceptOrder: return "/orders/accept"
        case .getUserOrder(let id): return "/orders/\(id)/user"
        case .getUserOrders: return "/orders/user"
        case .getRestaurantOrder(let id): return "/orders/\(id)/restaurant"
        case .getRestaurantOrders: return "/orders/restaurant"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createOrder: return .post
        case .acceptOrder: return .post
        case .getUserOrder: return .get
        case .getUserOrders: return .get
        case .getRestaurantOrder: return .get
        case .getRestaurantOrders: return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .createOrder: return ["Content-Type": "application/json"]
        case .acceptOrder: return ["Content-Type": "application/json"]
        case .getUserOrder: return ["Content-Type": "application/json"]
        case .getUserOrders: return ["Content-Type": "application/json"]
        case .getRestaurantOrder: return ["Content-Type": "application/json"]
        case .getRestaurantOrders: return ["Content-Type": "application/json"]
        }
    }
    
    var queryRequestable: QueryRequestable? {
        switch self {
        case .createOrder: return nil
        case .acceptOrder: return nil
        case .getUserOrder: return nil
        case .getUserOrders: return nil
        case .getRestaurantOrder: return nil
        case .getRestaurantOrders: return nil
        }
    }
    
    var bodyRequestable: BodyRequestable? {
        switch self {
        case .createOrder(let bodyRequest): return bodyRequest
        case .acceptOrder(let bodyRequest): return bodyRequest
        case .getUserOrder: return nil
        case .getUserOrders: return nil
        case .getRestaurantOrder: return nil
        case .getRestaurantOrders: return nil
        }
    }
    
    var multipartFormDataRequestable: MultipartFormDataRequestable? {
        return nil
    }
}
