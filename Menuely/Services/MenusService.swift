//
//  MenusService.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 26.07.2021..
//

import Foundation
import Combine
import Resolver

protocol MenusServicing {
    func getMenus(with queryRequest: QueryRequestable, menus: LoadableSubject<[Menu]>)
    func createMenu(with bodyRequest: BodyRequestable, createMenuResult: LoadableSubject<Discardable>)
    func updateMenu(with id: PathParameter, and bodyRequest: BodyRequestable, updateMenuResult: LoadableSubject<Discardable>)
    func deleteMenu(with id: PathParameter, deleteMenuResult: LoadableSubject<Discardable>)
}

class MenusService: MenusServicing {
    @Injected private var appState: Store<AppState>
    @Injected private var remoteRepository: MenusRemoteRepositing
    
    let cancelBag = CancelBag()
    
    func getMenus(with queryRequest: QueryRequestable, menus: LoadableSubject<[Menu]>) {
        menus.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.getMenus(with: queryRequest)
            }
            .map { $0.menus }
            .sinkToLoadable { menus.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func createMenu(with bodyRequest: BodyRequestable, createMenuResult: LoadableSubject<Discardable>) {
        createMenuResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.createMenu(with: bodyRequest)
            }
            .sinkToLoadable {
                createMenuResult.wrappedValue = $0
            }
            .store(in: cancelBag)
    }
    
    func updateMenu(with id: PathParameter, and bodyRequest: BodyRequestable, updateMenuResult: LoadableSubject<Discardable>) {
        updateMenuResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.updateMenu(with: id, and: bodyRequest)
            }
            .sinkToLoadable {
                updateMenuResult.wrappedValue = $0
            }
            .store(in: cancelBag)
    }
    
    func deleteMenu(with id: PathParameter, deleteMenuResult: LoadableSubject<Discardable>) {
        deleteMenuResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.deleteMenu(with: id)
            }
            .sinkToLoadable { deleteMenuResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}
