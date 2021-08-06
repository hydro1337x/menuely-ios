//
//  RestaurantsSearchListViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 31.07.2021..
//

import Foundation
import Resolver

extension RestaurantsSearchListView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        @Injected private var restaurantsService: RestaurantsServicing
        
        @Published var routing: Routing
        @Published var restaurants: Loadable<[Restaurant]>
        
        var appState: Store<AppState>
        private var cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>, restaurants: Loadable<[Restaurant]> = .notRequested) {
            self.appState = appState
            
            _routing = .init(initialValue: appState[\.routing.restaurantsSearch])
            
            _restaurants = .init(initialValue: restaurants)
            
            cancelBag.collect {
                appState
                    .map(\.data.searchList.search)
                    .removeDuplicates()
                    .compactMap { $0 }
                    .sink { [weak self] in
                        self?.getRestaurants(with: $0)
                    }
                
                $routing
                    .removeDuplicates()
                    .sink { appState[\.routing.restaurantsSearch] = $0 }
                
                appState
                    .map(\.routing.restaurantsSearch)
                    .removeDuplicates()
                    .assign(to: \.routing, on: self)
            }
        }
        
        // MARK: - Methods
        func getRestaurants(with search: String) {
            let queryRequest = SearchQueryRequest(search: search)
            restaurantsService.getRestaurants(with: queryRequest, restaurants: loadableSubject(\.restaurants))
        }
        
        func resetStates() {
            restaurants.reset()
        }
        
        // MARK: - Routing
        func errorView(with message: String?) {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
        }
        
        func restaurantNoticeView(for restaurant: Restaurant) {
            let info = RestaurantNoticeInfo(restaurantID: restaurant.id)
            routing.restaurantNoticeForInfo = info
        }
    }
}
