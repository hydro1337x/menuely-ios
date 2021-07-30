//
//  ProductsRemoteRepository.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.07.2021..
//

import Foundation

import Foundation
import Resolver
import Combine
import Alamofire

protocol ProductsRemoteRepositing {
    func getProducts(with queryRequest: QueryRequestable) -> AnyPublisher<ProductsListResponse, Error>
    func createProduct(with multipartFormDataRequest: MultipartFormDataRequestable) -> AnyPublisher<Discardable, Error>
    func updateProduct(with id: PathParameter, and multipartFormDataRequest: MultipartFormDataRequestable) -> AnyPublisher<Discardable, Error>
    func deleteProduct(with id: PathParameter) -> AnyPublisher<Discardable, Error>
}

class ProductsRemoteRepository: ProductsRemoteRepositing {
    @Injected private var networkClient: Networking
    
    func getProducts(with queryRequest: QueryRequestable) -> AnyPublisher<ProductsListResponse, Error> {
        networkClient.request(endpoint: Endpoint.getProducts(queryRequest))
    }
    
    func createProduct(with multipartFormDataRequest: MultipartFormDataRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.createProduct(multipartFormDataRequest))
    }
    
    func updateProduct(with id: PathParameter, and multipartFormDataRequest: MultipartFormDataRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.updateProduct(id, multipartFormDataRequest))
    }
    
    func deleteProduct(with id: PathParameter) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.deleteProduct(id))
    }
}

// MARK: - Endpoints

extension ProductsRemoteRepository {
    enum Endpoint {
        case getProducts(QueryRequestable)
        case createProduct(MultipartFormDataRequestable)
        case updateProduct(PathParameter, MultipartFormDataRequestable)
        case deleteProduct(PathParameter)
    }
}

extension ProductsRemoteRepository.Endpoint: APIConfigurable {
    var path: String {
        switch self {
        case .getProducts: return "/offers/products"
        case .createProduct: return "/offers/products"
        case .updateProduct(let id, _): return "offers/products/\(id)"
        case .deleteProduct(let id): return "offers/products/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProducts: return .get
        case .createProduct: return .post
        case .updateProduct: return .patch
        case .deleteProduct: return .delete
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var queryRequestable: QueryRequestable? {
        switch self {
        case .getProducts(let queryRequest): return queryRequest
        case .createProduct: return nil
        case .updateProduct: return nil
        case .deleteProduct: return nil
        }
    }
    
    var bodyRequestable: BodyRequestable? {
        return nil
    }
    
    var multipartFormDataRequestable: MultipartFormDataRequestable? {
        switch self {
        case .getProducts: return nil
        case .createProduct(let multipartFormDataRequest): return multipartFormDataRequest
        case .updateProduct(_, let multipartFormDataRequest): return multipartFormDataRequest
        case .deleteProduct: return nil
        }
    }
}
