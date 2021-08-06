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
        
        @Published var routing: Routing
        @Published var restaurant: Loadable<Restaurant>
        @Published var tag: Int = -1
        
        var appState: Store<AppState>
        private let cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>, restaurant: Loadable<Restaurant> = .notRequested) {
            self.appState = appState
            
            _routing = .init(initialValue: appState[\.routing.restaurantNotice])
            
            _restaurant = .init(initialValue: restaurant)
            
            cancelBag.collect {
                $routing
                    .removeDuplicates()
                    .sink { appState[\.routing.restaurantNotice] = $0 }
                
                appState
                    .map(\.routing.restaurantNotice)
                    .removeDuplicates()
                    .assign(to: \.routing, on: self)
            }
        }
        
        // MARK: - Methods
        func getRestaurant() {
            guard let restaurantID = appState[\.routing.restaurantsSearch.restaurantNoticeForInfo]?.restaurantID ?? appState[\.routing.scan.restaurantNoticeForInfo]?.restaurantID else { return }  
            restaurantsService.getRestaurant(with: restaurantID, restaurant: loadableSubject(\.restaurant))
        }
        
        // MARK: - Routing
        func errorView(with message: String?) {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
        }
        
        func dismiss() {
            appState[\.routing.restaurantsSearch.restaurantNoticeForInfo] = nil
            appState[\.routing.scan.restaurantNoticeForInfo] = nil
        }
    }
}
