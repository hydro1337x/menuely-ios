//
//  OrdersService.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 12.08.2021..
//

import Foundation
import Combine
import Resolver

protocol OrdersServicing {
    func createOrder(with bodyRequest: BodyRequestable, createOrderResult: LoadableSubject<Discardable>)
}

class OrdersService: OrdersServicing {
    @Injected private var appState: Store<AppState>
    @Injected private var remoteRepository: OrdersRemoteRepositing
    
    let cancelBag = CancelBag()
    
    func createOrder(with bodyRequest: BodyRequestable, createOrderResult: LoadableSubject<Discardable>) {
        createOrderResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.createOrder(with: bodyRequest)
            }
            .sinkToLoadable { createOrderResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}
