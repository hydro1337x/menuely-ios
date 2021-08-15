//
//  RestaurantOrdersListViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 15.08.2021..
//

import Foundation
import Resolver
import SwiftUI

extension RestaurantOrdersListView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        @Injected private var ordersService: OrdersServicing
        @Injected private var dateUtility: DateUtility
        
        @Published var routing: Routing
        @Published var orders: Loadable<[Order]>
        
        let appState: Store<AppState>
        private var cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>, orders: Loadable<[Order]> = .notRequested) {
            self.appState = appState
            
            _routing = .init(initialValue: appState[\.routing.restaurantOrdersList])
            _orders = .init(initialValue: orders)
            
            cancelBag.collect {
                $routing
                    .removeDuplicates()
                    .sink { appState[\.routing.restaurantOrdersList] = $0 }
                
                appState
                    .map(\.routing.restaurantOrdersList)
                    .removeDuplicates()
                    .assign(to: \.routing, on: self)
            }
        }
        
        // MARK: - Methods
        func resetStates() {
            orders.reset()
        }
        
        func getOrders() {
            ordersService.getRestaurantOrders(orders: loadableSubject(\.orders))
        }
        
        func timeIntervalToString(_ timeInterval: TimeInterval) -> String {
            return dateUtility.formatToString(from: timeInterval, with: .full)
        }
        
        func format(price: Float, currency: String) -> String {
            return String(format: "%.2f", price) + " \(currency)"
        }
        
        // MARK: - Routing
        func errorView(with message: String?) {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
        }
    }
}
