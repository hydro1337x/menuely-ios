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
    func uploadImage(with dataParameters: DataParameters, ofKind kind: ImageKind)
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
            .sinkToLoadable { restaurant.wrappedValue = $0 }
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
            .sinkToLoadable { restaurant.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func uploadImage(with dataParameters: DataParameters, ofKind kind: ImageKind) {
        remoteRepository.uploadImage(with: kind.asParameter, and: dataParameters)
            .sink { completion in
                print("Upload complete: ", completion)
            } receiveValue: { discardable in
//                print(discardable)
            }
            .store(in: cancelBag)

    }
}
