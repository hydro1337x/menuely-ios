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
        
        let appState: Store<AppState>
        private var cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>) {
            self.appState = appState
        }
        
        // MARK: - Methods
    }
}
