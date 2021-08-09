//
//  CartViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 02.08.2021..
//

import Foundation
import Resolver

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
        
        // MARK: - Routing
        func dismiss() {
            appState[\.routing.restaurantNotice.cart] = nil
            appState[\.routing.categoriesList.cart] = nil
            appState[\.routing.productsList.cart] = nil
        }
    }
}
