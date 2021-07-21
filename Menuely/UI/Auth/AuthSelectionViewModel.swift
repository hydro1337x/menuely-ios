//
//  AuthSelectionViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 21.07.2021..
//

import Foundation

class AuthSelectionViewModel: ObservableObject {
    
    @Published var routing: AuthSelectionView.Routing
    
    var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    init(appState: Store<AppState>) {
        self.appState = appState
        
        _routing = .init(initialValue: appState[\.routing.authSelection])
        
        cancelBag.collect {
            $routing
                .removeDuplicates()
                .sink { appState[\.routing.authSelection] = $0 }
            
            appState
                .map(\.routing.authSelection)
                .removeDuplicates()
                .assign(to: \.routing, on: self)
        }
    }
    
}
