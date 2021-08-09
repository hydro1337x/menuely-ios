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
        
        @Published var cart: Cart?
        
        let appState: Store<AppState>
        private var cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>) {
            self.appState = appState
            
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
        
        func format(price: Float, currency: String) -> String {
            return String(format: "%.2f", price) + " \(currency)"
        }
        
        // MARK: - Routing
        func deletionAlertView(for cartItem: CartItem, with action: @escaping () -> Void) {
            let configuration = AlertViewConfiguration(title: "Delete item", message: "Are you sure you want to delete \(cartItem.name)", primaryAction: {
                self.appState[\.routing.alert.configuration] = nil
                self.remove(cartItem: cartItem)
                if let cart = self.cart, cart.cartItems.isEmpty {
                    action()
                }
            }, primaryButtonTitle: "Delete", secondaryAction: {
                self.appState[\.routing.alert.configuration] = nil
            }, secondaryButtonTitle: "Cancel")
            appState[\.routing.alert.configuration] = configuration
        }
        
        func actionView(for cartItem: CartItem, with onEmptyAction: @escaping () -> Void, and additionalAction: @escaping () -> Void) {
            let delete = Action(name: "Delete") {
                self.appState[\.routing.action.configuration] = nil
                self.deletionAlertView(for: cartItem, with: onEmptyAction)
            }
            
            let configuration = ActionViewConfiguration(title: "\(cartItem.name) actions", actions: [delete]) {
                additionalAction()
                self.appState[\.routing.action.configuration] = nil
            }
            
            appState[\.routing.action.configuration] = configuration
        }
    }
}
