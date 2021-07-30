//
//  RootViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 20.07.2021..
//

import Foundation
import Resolver

class RootViewModel: ObservableObject {
    
    @Published var routing: RootView.Routing
    
    private var cancelBag = CancelBag()
    
    init(authService: AuthServicing, appState: Store<AppState>) {
        _routing = .init(initialValue: authService.currentAuthenticatedEntity == nil ? .auth : .tabs)
        appState[\.data.selectedEntity] = authService.authenticatedRestaurant == nil ? .user : .restaurant
        appState[\.data.authenticatedUser] = authService.authenticatedUser
        appState[\.data.authenticatedRestaurant] = authService.authenticatedRestaurant
        
        cancelBag.collect {
            $routing
                .removeDuplicates()
                .sink { appState[\.routing.root] = $0 }
            
            appState
                .map(\.routing.root)
                .removeDuplicates()
                .assign(to: \.routing, on: self)
        }
    }
    
}
