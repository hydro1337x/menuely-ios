//
//  RestaurantOrderDetailsViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 16.08.2021..
//

import Foundation
import Resolver
import SwiftUI

extension RestaurantOrderDetailsView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        @Injected private var ordersService: OrdersServicing
        @Published var order: Loadable<Order>
        @Published var acceptOrderResult: Loadable<Discardable>
        
        var title: String {
            return order.value?.id.description ?? ""
        }
        let appState: Store<AppState>
        private var cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>, order: Loadable<Order> = .notRequested, acceptOrderResult: Loadable<Discardable> = .notRequested) {
            self.appState = appState
            
            _acceptOrderResult = .init(initialValue: acceptOrderResult)
            _order = .init(initialValue: order)
        }
        
        // MARK: - Methods
        
        func getOrder() {
            guard let id = appState[\.routing.restaurantOrdersList.orderDetailsForId] else { return }
            ordersService.getRestaurantOrder(with: id, order: loadableSubject(\.order))
        }
        
        func acceptOrder(with id: Int) {
            let bodyRequest = AcceptOrderBodyRequest(orderId: id)
            ordersService.acceptOrder(with: bodyRequest, acceptOrderResult: loadableSubject(\.acceptOrderResult))
        }
        
        func format(price: Float, currency: String) -> String {
            return String(format: "%.2f", price) + " \(currency)"
        }
        
        func resetStates() {
            order.reset()
            acceptOrderResult.reset()
        }
        
        func updateRestaurantListView() {
            appState[\.data.updateRestaurantOrdersListView] = true
        }
        
        // MARK: - Routing
        func errorView(with message: String?) {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
        }
        
        func infoView() {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Order", message: "Order successfully accepted")
        }
        
        func dismiss() {
            appState[\.routing.restaurantOrdersList.orderDetailsForId] = nil
        }
    }
}
