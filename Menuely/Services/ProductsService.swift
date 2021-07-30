//
//  ProductsService.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.07.2021..
//

import Foundation
import Combine
import Resolver

protocol ProductsServicing {
    func getProducts(with queryRequest: QueryRequestable, products: LoadableSubject<[Product]>)
    func createProduct(with multipartFormDataRequest: MultipartFormDataRequestable, createProductResult: LoadableSubject<Discardable>)
    func updateProduct(with id: PathParameter, and multipartFormDataRequest: MultipartFormDataRequestable, updateProductResult: LoadableSubject<Discardable>)
    func deleteProduct(with id: PathParameter, deleteProductResult: LoadableSubject<Discardable>)
}

class ProductsService: ProductsServicing {
    @Injected private var appState: Store<AppState>
    @Injected private var remoteRepository: ProductsRemoteRepositing
    
    let cancelBag = CancelBag()
    
    func getProducts(with queryRequest: QueryRequestable, products: LoadableSubject<[Product]>) {
        products.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.getProducts(with: queryRequest)
            }
            .map { $0.products }
            .sinkToLoadable { products.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func createProduct(with multipartFormDataRequest: MultipartFormDataRequestable, createProductResult: LoadableSubject<Discardable>) {
        createProductResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.createProduct(with: multipartFormDataRequest)
            }
            .sinkToLoadable {
                createProductResult.wrappedValue = $0
            }
            .store(in: cancelBag)
    }
    
    func updateProduct(with id: PathParameter, and multipartFormDataRequest: MultipartFormDataRequestable, updateProductResult: LoadableSubject<Discardable>) {
        updateProductResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.updateProduct(with: id, and: multipartFormDataRequest)
            }
            .sinkToLoadable {
                updateProductResult.wrappedValue = $0
            }
            .store(in: cancelBag)
    }
    
    func deleteProduct(with id: PathParameter, deleteProductResult: LoadableSubject<Discardable>) {
        deleteProductResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.deleteProduct(with: id)
            }
            .sinkToLoadable { deleteProductResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}
