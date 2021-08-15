//
//  UserOrderDetailsViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 13.08.2021..
//

import Foundation
import Resolver
import SwiftUI

extension UserOrderDetailsView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        @Injected private var ordersService: OrdersServicing
        @Published var order: Loadable<Order>
        
        var title: String {
            return order.value?.id.description ?? ""
        }
        let appState: Store<AppState>
        private var cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>, order: Loadable<Order> = .notRequested) {
            self.appState = appState
            
            _order = .init(initialValue: order)
        }
        
        // MARK: - Methods
        
        func getOrder() {
            guard let id = appState[\.routing.userOrdersList.orderDetailsForId] else { return }
            ordersService.getUserOrder(with: id, order: loadableSubject(\.order))
        }
        
        func format(price: Float, currency: String) -> String {
            return String(format: "%.2f", price) + " \(currency)"
        }
        
        // MARK: - Routing
        func errorView(with message: String?) {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
        }
        
        func dismiss() {
            appState[\.routing.userOrdersList.orderDetailsForId] = nil
        }
    }
}
