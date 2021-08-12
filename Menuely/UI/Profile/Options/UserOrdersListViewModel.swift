//
//  UserOrdersListViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 12.08.2021..
//

import Foundation

import Resolver
import SwiftUI

extension UserOrdersListView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        @Injected private var ordersService: OrdersServicing
        
        @Published var orders: Loadable<[Order]>
        
        let appState: Store<AppState>
        private var cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>, orders: Loadable<[Order]> = .notRequested) {
            self.appState = appState
            
            _orders = .init(initialValue: orders)
        }
        
        // MARK: - Methods
        func resetStates() {
            orders.reset()
        }
        
        func getOrders() {
            ordersService.getUserOrders(orders: loadableSubject(\.orders))
        }
        
        // MARK: - Routing
        func errorView(with message: String?) {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
        }
    }
}
