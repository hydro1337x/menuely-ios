//
//  CartViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 02.08.2021..
//

import Foundation
import Resolver
import SwiftUI

extension CartView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        @Injected private var cartService: CartServicing
        @Injected private var ordersService: OrdersServicing
        
        @Published var createOrderResult: Loadable<Discardable>
        @Published var cart: Cart?
        
        let appState: Store<AppState>
        private var cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>, createOrderResult: Loadable<Discardable> = .notRequested) {
            self.appState = appState
            
            _createOrderResult = .init(initialValue: createOrderResult)
            _cart = .init(initialValue: appState[\.data.cart])
            
            cancelBag.collect {
                appState
                    .map(\.data.cart)
                    .removeDuplicates()
                    .assign(to: \.cart, on: self)  
            }
        }
        
        // MARK: - Methods
        func incrementQuantity(for cartItem: CartItem) {
            cartService.add(cartItem)
        }
        
        func decrementQuantity(for cartItem: CartItem) {
            cartService.decrementQuantity(for: cartItem)
        }
        
        func remove(cartItem: CartItem) {
            withAnimation {
                cartService.remove(cartItem)
            }
        }
        
        func deleteCart() {
            cartService.deleteCart()
        }
        
        func format(price: Float, currency: String) -> String {
            return String(format: "%.2f", price) + " \(currency)"
        }
        
        func createOrder() {
            let bodyRequest = cartService.cartAsRequest()
            ordersService.createOrder(with: bodyRequest, createOrderResult: loadableSubject(\.createOrderResult))
        }
        
        func resetStates() {
            createOrderResult.reset()
        }
        
        // MARK: - Routing
        func deletionAlertView(for cartItem: CartItem, with onEmptyAction: @escaping () -> Void) {
            let configuration = AlertViewConfiguration(title: "Delete item", message: "Are you sure you want to delete \(cartItem.name)", primaryAction: {
                self.appState[\.routing.alert.configuration] = nil
                self.remove(cartItem: cartItem)
                if let cart = self.cart, cart.cartItems.isEmpty {
                    onEmptyAction()
                }
            }, primaryButtonTitle: "Delete", secondaryAction: {
                self.appState[\.routing.alert.configuration] = nil
            }, secondaryButtonTitle: "Cancel")
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.appState[\.routing.alert.configuration] = configuration
            }
        }
        
        func errorView(with message: String?) {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
        }
        
        func alertView() {
            let configuration = AlertViewConfiguration(title: "Order successfully created", message: "You can view your orders inside your profile", primaryAction: dismiss, primaryButtonTitle: "OK", secondaryAction: nil, secondaryButtonTitle: nil)
            appState[\.routing.alert.configuration] = configuration
        }
        
        func dismiss() {
            appState[\.routing.alert.configuration] = nil
            appState[\.routing.productsList] = ProductsListView.Routing()
            appState[\.routing.categoriesList] = CategoriesListView.Routing()
            appState[\.routing.restaurantNotice] = RestaurantNoticeView.Routing()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.deleteCart()
                self.appState[\.routing.scan.restaurantNoticeForInfo] = nil
            }
            
        }
    }
}
