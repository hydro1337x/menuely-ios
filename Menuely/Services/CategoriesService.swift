//
//  CategoriesService.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 29.07.2021..
//

import Foundation
import Combine
import Resolver

protocol CategoriesServicing {
    func getCategories(with queryRequest: QueryRequestable, categories: LoadableSubject<[Category]>)
    func createCategory(with multipartFormDataRequest: MultipartFormDataRequestable, createCategoryResult: LoadableSubject<Discardable>)
    func updateCategory(with id: PathParameter, and multipartFormDataRequest: MultipartFormDataRequestable, updateCategoryResult: LoadableSubject<Discardable>)
    func deleteCategory(with id: PathParameter, deleteCategoryResult: LoadableSubject<Discardable>)
}

class CategoriesService: CategoriesServicing {
    @Injected private var appState: Store<AppState>
    @Injected private var remoteRepository: CategoriesRemoteRepositing
    
    let cancelBag = CancelBag()
    
    func getCategories(with queryRequest: QueryRequestable, categories: LoadableSubject<[Category]>) {
        categories.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.getCategories(with: queryRequest)
            }
            .map { $0.categories }
            .sinkToLoadable { categories.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func createCategory(with multipartFormDataRequest: MultipartFormDataRequestable, createCategoryResult: LoadableSubject<Discardable>) {
        createCategoryResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.createCategory(with: multipartFormDataRequest)
            }
            .sinkToLoadable {
                createCategoryResult.wrappedValue = $0
            }
            .store(in: cancelBag)
    }
    
    func updateCategory(with id: PathParameter, and multipartFormDataRequest: MultipartFormDataRequestable, updateCategoryResult: LoadableSubject<Discardable>) {
        updateCategoryResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.updateCategory(with: id, and: multipartFormDataRequest)
            }
            .sinkToLoadable {
                updateCategoryResult.wrappedValue = $0
            }
            .store(in: cancelBag)
    }
    
    func deleteCategory(with id: PathParameter, deleteCategoryResult: LoadableSubject<Discardable>) {
        deleteCategoryResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.deleteCategory(with: id)
            }
            .sinkToLoadable { deleteCategoryResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}
