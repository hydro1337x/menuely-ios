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
        @Injected private var cartService: CartServicing
        
        @Published var cart: Cart?
        @Published var routing: Routing
        @Published var restaurant: Loadable<Restaurant>
        
        var appState: Store<AppState>
        private let cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>, restaurant: Loadable<Restaurant> = .notRequested) {
            self.appState = appState
            
            _cart = .init(initialValue: appState[\.data.cart])
            
            _routing = .init(initialValue: appState[\.routing.restaurantNotice])
            
            _restaurant = .init(initialValue: restaurant)
            
            cancelBag.collect {
                appState
                    .map(\.data.cart)
                    .removeDuplicates()
                    .assign(to: \.cart, on: self)
                
                $routing
                    .removeDuplicates()
                    .sink { appState[\.routing.restaurantNotice] = $0 }
                
                appState
                    .map(\.routing.restaurantNotice)
                    .removeDuplicates()
                    .assign(to: \.routing, on: self)
            }
            
            if let info = appState[\.routing.scan.restaurantNoticeForInfo], let tableID = info.tableID {
                cartService.createCart(for: info.restaurantID, and: tableID)
            }
        }
        
        // MARK: - Methods
        func getRestaurant() {
            guard let restaurantID = appState[\.routing.restaurantsSearch.restaurantNoticeForInfo]?.restaurantID ?? appState[\.routing.scan.restaurantNoticeForInfo]?.restaurantID ?? appState[\.routing.invitationsList.restaurantNoticeForInfo]?.restaurantID else { return }  
            restaurantsService.getRestaurant(with: restaurantID, restaurant: loadableSubject(\.restaurant))
        }
        
        // MARK: - Routing
        func errorView(with message: String?) {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
        }
        
        func dismiss() {
            appState[\.routing.invitationsList.restaurantNoticeForInfo] = nil
            appState[\.routing.restaurantsSearch.restaurantNoticeForInfo] = nil
            appState[\.routing.scan.restaurantNoticeForInfo] = nil
            cartService.deleteCart()
        }
        
        func categoriesView(for menuID: Int) {
            var interaction: OffersInteractionType = .viewing
            if appState[\.routing.scan.restaurantNoticeForInfo]?.tableID != nil {
                interaction = .buying
            }
            routing.categories = CategoriesListDisplayInfo(menuID: menuID, menuName: "Menu", interaction: interaction)
        }
    }
}
