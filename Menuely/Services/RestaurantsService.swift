//
//  RestaurantsService.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 22.07.2021..
//

import Foundation
import Combine
import Resolver

protocol RestaurantsServicing {
    func getRestaurants(with queryRequestable: QueryRequestable?, restaurants: LoadableSubject<[Restaurant]>)
    func getRestaurantProfile(restaurant: LoadableSubject<Restaurant>)
    func uploadImageAndGetRestaurantProfile(with multipartFormDataRequestable: MultipartFormDataRequestable, restaurant: LoadableSubject<Restaurant>)
    func uploadImage(with multipartFormDataRequestable: MultipartFormDataRequestable, imageResult: LoadableSubject<Discardable>)
    func updateRestaurantProfile(with bodyRequest: BodyRequestable, updateProfileResult: LoadableSubject<Discardable>)
    func updateRestaurantPassword(with bodyRequest: BodyRequestable, updatePasswordResult: LoadableSubject<Discardable>)
    func updateRestaurantEmail(with bodyRequest: BodyRequestable, updateEmailResult: LoadableSubject<Discardable>)
    func delete(deletionResult: LoadableSubject<Discardable>)
}

class RestaurantsService: RestaurantsServicing {
    @Injected private var appState: Store<AppState>
    @Injected private var remoteRepository: RestaurantsRemoteRepositing
    @Injected private var localRepository: LocalRepositing
    
    let cancelBag = CancelBag()
    
    func getRestaurants(with queryRequestable: QueryRequestable?, restaurants: LoadableSubject<[Restaurant]>) {
        restaurants.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                return remoteRepository.getRestaurants(with: queryRequestable)
            }
            .map { return $0.restaurants }
            .sinkToLoadable { restaurants.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func getRestaurantProfile(restaurant: LoadableSubject<Restaurant>) {
        restaurant.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.getRestaurantProfile()
            }
            .map { $0.restaurant }
            .sinkToLoadable {
                restaurant.wrappedValue = $0
                
                self.updateRestaurant($0.value)
            }
            .store(in: cancelBag)
    }
    
    func uploadImageAndGetRestaurantProfile(with multipartFormDataRequestable: MultipartFormDataRequestable, restaurant: LoadableSubject<Restaurant>) {
        restaurant.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.uploadImage(with: multipartFormDataRequestable)
            }
            .flatMap { [remoteRepository] _ in
                remoteRepository.getRestaurantProfile()
            }
            .map { $0.restaurant }
            .sinkToLoadable {
                restaurant.wrappedValue = $0
                
                self.updateRestaurant($0.value)
            }
            .store(in: cancelBag)
    }
    
    func uploadImage(with multipartFormDataRequestable: MultipartFormDataRequestable, imageResult: LoadableSubject<Discardable>) {
        imageResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.uploadImage(with: multipartFormDataRequestable)
            }
            .sinkToLoadable { imageResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func updateRestaurantProfile(with bodyRequest: BodyRequestable, updateProfileResult: LoadableSubject<Discardable>) {
        updateProfileResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.updateRestaurantProfile(with: bodyRequest)
            }
            .sinkToLoadable { updateProfileResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func updateRestaurantPassword(with bodyRequest: BodyRequestable, updatePasswordResult: LoadableSubject<Discardable>) {
        updatePasswordResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.updateRestaurantPassword(with: bodyRequest)
            }
            .sinkToLoadable { updatePasswordResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func updateRestaurantEmail(with bodyRequest: BodyRequestable, updateEmailResult: LoadableSubject<Discardable>) {
        updateEmailResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.updateRestaurantEmail(with: bodyRequest)
            }
            .sinkToLoadable { updateEmailResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func delete(deletionResult: LoadableSubject<Discardable>) {
        deletionResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.delete()
            }
            .sinkToLoadable {
                deletionResult.wrappedValue = $0
                
                if $0.value != nil {
                    self.removeAuthenticatedRestaurant()
                }
            }
            .store(in: cancelBag)
    }
    
    func updateRestaurant(_ restaurant: Restaurant?) {
        guard let tokens = appState[\.data.authenticatedRestaurant]?.auth, let restaurant = restaurant else { return }
        let updatedAuthenticatedRestaurant = AuthenticatedRestaurant(restaurant: restaurant, auth: tokens)
        appState[\.data.authenticatedRestaurant] = updatedAuthenticatedRestaurant
    }
    
    private func removeAuthenticatedRestaurant() {
        localRepository.removeValue(for: .authenticatedRestaurant)
    }
}
