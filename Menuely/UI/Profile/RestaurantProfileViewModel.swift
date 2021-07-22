//
//  RestaurantProfileViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 22.07.2021..
//

import Foundation
import Resolver

class RestaurantProfileViewModel: ObservableObject {
    // MARK: - Properties
    @Injected private var restaurantsService: RestaurantsServicing
    @Injected private var dateUtility: DateUtility
    
    @Published var routing: ProfileView.Routing
    @Published var restaurantProfile: Loadable<Restaurant>
    @Published var animateErrorView: Bool = false
    
    var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>, restaurantProfile: Loadable<Restaurant> = .notRequested) {
        self.appState = appState
        
        _restaurantProfile = .init(initialValue: restaurantProfile)
        
        _routing = .init(initialValue: appState[\.routing.profile])
        
        cancelBag.collect {
            $routing
                .removeDuplicates()
                .sink { appState[\.routing.profile] = $0 }
            
            appState
                .map(\.routing.profile)
                .removeDuplicates()
                .assign(to: \.routing, on: self)
        }
    }
    
    // MARK: - Methods
    func getRestaurantProfile() {
        restaurantsService.getRestaurantProfile(restaurant: loadableSubject(\.restaurantProfile))
    }
    
    func timeIntervalToString(_ timeInterval: TimeInterval) -> String {
        return dateUtility.formatToString(from: timeInterval, with: .full)
    }
    
    func resetStates() {
        restaurantProfile.reset()
    }
}
