//
//  RootViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 20.07.2021..
//

import Foundation

class RootViewModel: ObservableObject {
    
    @Published var routing: RootView.Routing
    
    private var cancelBag = CancelBag()
    
    init(authService: AuthServicing, appState: Store<AppState>) {
        _routing = .init(initialValue: authService.authenticatedEntity == nil ? .auth : .tabs)
        
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
