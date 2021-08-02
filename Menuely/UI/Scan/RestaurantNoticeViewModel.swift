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
            
            cancelBag.collect {
                appState
                    .map(\.routing.scan)
                    .removeDuplicates()
                    .compactMap { $0.menuForScannedRestaurantID }
                    .sink { [weak self] in
                        self?.getRestaurant(with: $0)
                    }
            }
        }
        
        // MARK: - Methods
        func getRestaurant(with id: Int) {
            restaurantsService.getRestaurant(with: 1, restaurant: loadableSubject(\.restaurant))
        }
        
        // MARK: - Routing
        func errorView(with message: String?) {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
        }
        
        func dismiss() {
            appState[\.routing.scan.menuForScannedRestaurantID] = nil
        }
    }
}
