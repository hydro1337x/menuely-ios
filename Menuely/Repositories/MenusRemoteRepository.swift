//
//  MenusRemoteRepository.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 26.07.2021..
//

import Foundation
import Resolver
import Combine
import UIKit

protocol MenusRemoteRepositing {
    func getMenus(with menusRequestDTO: MenusRequestDTO) -> AnyPublisher<MenusListResponseDTO, Error>
    func createMenu(with createMenuRequestDTO: CreateMenuRequestDTO) -> AnyPublisher<Discardable, Error>
    func updateMenu(with id: Int, and updateMenuRequestDTO: UpdateMenuRequestDTO) -> AnyPublisher<Discardable, Error>
    func deleteMenu(with id: Int) -> AnyPublisher<Discardable, Error>
}

class MenusRemoteRepository: MenusRemoteRepositing {
    @Injected private var networkClient: Networking
    
    func getMenus(with menusRequestDTO: MenusRequestDTO) -> AnyPublisher<MenusListResponseDTO, Error> {
        networkClient.request(endpoint: Endpoint.getMenus(menusRequestDTO))
    }
    
    func createMenu(with createMenuRequestDTO: CreateMenuRequestDTO) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.createMenu(createMenuRequestDTO))
    }
    
    func updateMenu(with id: Int, and updateMenuRequestDTO: UpdateMenuRequestDTO) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.updateMenu(id, updateMenuRequestDTO))
    }
    
    func deleteMenu(with id: Int) -> AnyPublisher<Discardable, Error> {
        networkClient.request(endpoint: Endpoint.deleteMenu(id))
    }
}

// MARK: - Endpoints

extension MenusRemoteRepository {
    enum Endpoint {
        case getMenus(MenusRequestDTO)
        case createMenu(CreateMenuRequestDTO)
        case updateMenu(Int, UpdateMenuRequestDTO)
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
    
    var queryParameters: Parameters? {
        switch self {
        case .getMenus(let menusRequestDTO): return menusRequestDTO.asDictionary
        case .createMenu: return nil
        case .updateMenu: return nil
        case .deleteMenu: return nil
        }
    }
    
    func body() throws -> Data? {
        switch self {
        case .getMenus: return nil
        case .createMenu(let createMenuRequestDTO): return try createMenuRequestDTO.asJSON()
        case .updateMenu(_, let updateMenuRequestDTO): return try updateMenuRequestDTO.asJSON()
        case .deleteMenu: return nil
        }
    }
}
