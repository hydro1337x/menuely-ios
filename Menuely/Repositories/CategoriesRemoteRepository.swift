//
//  CategoriesRemoteRepository.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 29.07.2021..
//

import Foundation
import Resolver
import Combine
import Alamofire

protocol CategoriesRemoteRepositing {
    func getCategories(with queryRequest: QueryRequestable) -> AnyPublisher<CategoriesListResponse, Error>
    func createCategory(with multipartFormDataRequest: MultipartFormDataRequestable) -> AnyPublisher<Discardable, Error>
    func updateCategory(with id: PathParameter, and multipartFormDataRequest: MultipartFormDataRequestable) -> AnyPublisher<Discardable, Error>
    func deleteCategory(with id: PathParameter) -> AnyPublisher<Discardable, Error>
}

class CategoriesRemoteRepository: CategoriesRemoteRepositing {
    @Injected private var networkClient: Networking
    
    func getCategories(with queryRequest: QueryRequestable) -> AnyPublisher<CategoriesListResponse, Error> {
        networkClient.request(endpoint: Endpoint.getCategories(queryRequest))
    }
    
    func createCategory(with multipartFormDataRequest: MultipartFormDataRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.createCategory(multipartFormDataRequest))
    }
    
    func updateCategory(with id: PathParameter, and multipartFormDataRequest: MultipartFormDataRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.updateCategory(id, multipartFormDataRequest))
    }
    
    func deleteCategory(with id: PathParameter) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.deleteCategory(id))
    }
}

// MARK: - Endpoints

extension CategoriesRemoteRepository {
    enum Endpoint {
        case getCategories(QueryRequestable)
        case createCategory(MultipartFormDataRequestable)
        case updateCategory(PathParameter, MultipartFormDataRequestable)
        case deleteCategory(PathParameter)
    }
}

extension CategoriesRemoteRepository.Endpoint: APIConfigurable {
    var path: String {
        switch self {
        case .getCategories: return "/offers/categories"
        case .createCategory: return "/offers/categories"
        case .updateCategory(let id, _): return "offers/categories/\(id)"
        case .deleteCategory(let id): return "offers/categories/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCategories: return .get
        case .createCategory: return .post
        case .updateCategory: return .patch
        case .deleteCategory: return .delete
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var queryRequestable: QueryRequestable? {
        switch self {
        case .getCategories(let queryRequest): return queryRequest
        case .createCategory: return nil
        case .updateCategory: return nil
        case .deleteCategory: return nil
        }
    }
    
    var bodyRequestable: BodyRequestable? {
        return nil
    }
    
    var multipartFormDataRequestable: MultipartFormDataRequestable? {
        switch self {
        case .getCategories: return nil
        case .createCategory(let multipartFormDataRequest): return multipartFormDataRequest
        case .updateCategory(_, let multipartFormDataRequest): return multipartFormDataRequest
        case .deleteCategory: return nil
        }
    }
}
