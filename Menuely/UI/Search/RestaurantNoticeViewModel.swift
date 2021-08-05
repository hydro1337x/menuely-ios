//
//  RestaurantNoticeViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.08.2021..
//

import Foundation
import Resolver

extension RestaurantNoticeView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        @Injected private var restaurantsService: RestaurantsServicing
        
        @Published var restaurant: Loadable<Restaurant>
        
        var appState: Store<AppState>
        private let cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>, restaurant: Loadable<Restaurant> = .notRequested) {
            self.appState = appState
            
            _restaurant = .init(initialValue: restaurant)
        }
        
        // MARK: - Methods
        func getRestaurant() {
            guard let id = appState[\.routing.restaurantsSearch.restaurantNoticeForID] ?? appState[\.routing.scan.restaurantNoticeForID] else { return }
            restaurantsService.getRestaurant(with: id, restaurant: loadableSubject(\.restaurant))
        }
        
        // MARK: - Routing
        func errorView(with message: String?) {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
        }
        
        func dismiss() {
            appState[\.routing.scan.restaurantNoticeForID] = nil
        }
    }
}
