//
//  EditRestaurantProfileViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 23.07.2021..
//

import Foundation
import Resolver

class EditRestaurantProfileViewModel: ObservableObject {
    // MARK: - Properties
    @Injected private var restaurantsService: RestaurantsServicing
    
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var country: String = ""
    @Published var city: String = ""
    @Published var address: String = ""
    @Published var postalCode: String = ""
    @Published var updateProfileResult: Loadable<Discardable>
    
    @Published var animateErrorView: Bool = false
    
    var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>, updateProfileResult: Loadable<Discardable> = .notRequested) {
        self.appState = appState
        
        _updateProfileResult = .init(initialValue: updateProfileResult)
        
        if let restaurant = appState[\.data.authenticatedRestaurant]?.restaurant {
            name = restaurant.name
            description = restaurant.description
            country = restaurant.country
            city = restaurant.city
            address = restaurant.address
            postalCode = restaurant.postalCode
        }
        
        $updateProfileResult.sink { loadable in
            switch loadable {
            case .failed(_): self.animateErrorView = true
            default: self.animateErrorView = false
            }
        }
        .store(in: cancelBag)
    }
    
    // MARK: - Methods
    func updateRestaurantProfile() {
        let restaurantUpdateProfileRequestDTO = RestaurantUpdateProfileRequestDTO(name: name,
                                                                                  description: description,
                                                                                  country: country,
                                                                                  city: city,
                                                                                  address: address,
                                                                                  postalCode: postalCode)
        restaurantsService.updateRestaurantProfile(with: restaurantUpdateProfileRequestDTO, updateProfileResult: loadableSubject(\.updateProfileResult))
    }
    
    func resetStates() {
        updateProfileResult.reset()
    }
}
