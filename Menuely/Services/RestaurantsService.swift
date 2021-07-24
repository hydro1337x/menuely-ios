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
    func get(restaurants: LoadableSubject<[Restaurant]>, search: String)
    func getRestaurantProfile(restaurant: LoadableSubject<Restaurant>)
    func uploadImageAndGetRestaurantProfile(with dataParameters: DataParameters, ofKind kind: ImageKind, restaurant: LoadableSubject<Restaurant>)
    func uploadImage(with dataParameters: DataParameters, ofKind kind: ImageKind, imageResult: LoadableSubject<Discardable>)
    func updateRestaurantProfile(with restaurantUpdateProfileRequestDTO: RestaurantUpdateProfileRequestDTO, updateProfileResult: LoadableSubject<Discardable>)
    func updateRestaurantPassword(with updatePasswordRequestDTO: UpdatePasswordRequestDTO, updatePasswordResult: LoadableSubject<Discardable>)
    func updateRestaurantEmail(with updateEmailRequestDTO: UpdateEmailRequestDTO, updateEmailResult: LoadableSubject<Discardable>)
}

class RestaurantsService: RestaurantsServicing {
    @Injected var appState: Store<AppState>
    @Injected var remoteRepository: RestaurantsRemoteRepositing
    
    let cancelBag = CancelBag()
    
    func get(restaurants: LoadableSubject<[Restaurant]>, search: String) {
        restaurants.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                return remoteRepository.getRestaurants()
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
            .map { $0.data }
            .sinkToLoadable {
                restaurant.wrappedValue = $0
                
                self.updateRestaurant($0.value)
            }
            .store(in: cancelBag)
    }
    
    func uploadImageAndGetRestaurantProfile(with dataParameters: DataParameters, ofKind kind: ImageKind, restaurant: LoadableSubject<Restaurant>) {
        restaurant.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.uploadImage(with: kind.asParameter, and: dataParameters)
            }
            .flatMap { [remoteRepository] _ in
                remoteRepository.getRestaurantProfile()
            }
            .map { $0.data }
            .sinkToLoadable {
                restaurant.wrappedValue = $0
                
                self.updateRestaurant($0.value)
            }
            .store(in: cancelBag)
    }
    
    func uploadImage(with dataParameters: DataParameters, ofKind kind: ImageKind, imageResult: LoadableSubject<Discardable>) {
        imageResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.uploadImage(with: kind.asParameter, and: dataParameters)
            }
            .sinkToLoadable { imageResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func updateRestaurantProfile(with restaurantUpdateProfileRequestDTO: RestaurantUpdateProfileRequestDTO, updateProfileResult: LoadableSubject<Discardable>) {
        updateProfileResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.updateRestaurantProfile(with: restaurantUpdateProfileRequestDTO)
            }
            .sinkToLoadable { updateProfileResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func updateRestaurantPassword(with updatePasswordRequestDTO: UpdatePasswordRequestDTO, updatePasswordResult: LoadableSubject<Discardable>) {
        updatePasswordResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.updateRestaurantPassword(with: updatePasswordRequestDTO)
            }
            .sinkToLoadable { updatePasswordResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func updateRestaurantEmail(with updateEmailRequestDTO: UpdateEmailRequestDTO, updateEmailResult: LoadableSubject<Discardable>) {
        updateEmailResult.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [remoteRepository] in
                remoteRepository.updateRestaurantEmail(with: updateEmailRequestDTO)
            }
            .sinkToLoadable { updateEmailResult.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func updateRestaurant(_ restaurant: Restaurant?) {
        guard let tokens = appState[\.data.authenticatedRestaurant]?.auth, let restaurant = restaurant else { return }
        let updatedAuthenticatedRestaurant = AuthenticatedRestaurant(restaurant: restaurant, auth: tokens)
        appState[\.data.authenticatedRestaurant] = updatedAuthenticatedRestaurant
    }
}
