//
//  MenusRemoteRepository.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 26.07.2021..
//

import Foundation
import Resolver
import Combine
import Alamofire

protocol MenusRemoteRepositing {
    func getMenus(with queryRequestable: QueryRequestable) -> AnyPublisher<MenusListResponse, Error>
    func createMenu(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error>
    func updateMenu(with id: Int, and bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error>
    func deleteMenu(with id: Int) -> AnyPublisher<Discardable, Error>
}

class MenusRemoteRepository: MenusRemoteRepositing {
    @Injected private var networkClient: Networking
    
    func getMenus(with queryRequestable: QueryRequestable) -> AnyPublisher<MenusListResponse, Error> {
        networkClient.request(endpoint: Endpoint.getMenus(queryRequestable))
    }
    
    func createMenu(with bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.createMenu(bodyRequest))
    }
    
    func updateMenu(with id: Int, and bodyRequest: BodyRequestable) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.updateMenu(id, bodyRequest))
    }
    
    func deleteMenu(with id: Int) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.deleteMenu(id))
    }
}

// MARK: - Endpoints

extension MenusRemoteRepository {
    enum Endpoint {
        case getMenus(QueryRequestable)
        case createMenu(BodyRequestable)
        case updateMenu(Int, BodyRequestable)
        case deleteMenu(Int)
    }
}

extension MenusRemoteRepository.Endpoint: APIConfigurable {
    var path: String {
        switch self {
        case .getMenus: return "/offers/menus"
        case .createMenu: return "/offers/menus"
        case .updateMenu(let id, _): return "offers/menus/\(id)"
        case .deleteMenu(let id): return "offers/menus/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMenus: return .get
        case .createMenu: return .post
        case .updateMenu: return .patch
        case .deleteMenu: return .delete
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getMenus: return nil
        case .createMenu: return ["Content-Type": "application/json"]
        case .updateMenu: return ["Content-Type": "application/json"]
        case .deleteMenu: return nil
        }
    }
    
    var queryRequestable: QueryRequestable? {
        switch self {
        case .getMenus(let queryRequestable): return queryRequestable
        case .createMenu: return nil
        case .updateMenu: return nil
        case .deleteMenu: return nil
        }
    }
    
    var bodyRequestable: BodyRequestable? {
        switch self {
        case .getMenus: return nil
        case .createMenu(let bodyRequest): return bodyRequest
        case .updateMenu(_, let bodyRequest): return bodyRequest
        case .deleteMenu: return nil
        }
    }
    
    var multipartFormDataRequestable: MultipartFormDataRequestable? {
        return nil
    }
}
