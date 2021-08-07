//
//  CartViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 02.08.2021..
//

import Foundation

extension CartView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
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
    }
}
