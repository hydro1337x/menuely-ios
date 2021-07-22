//
//  AuthSelectionViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 21.07.2021..
//

import Foundation

class AuthSelectionViewModel: ObservableObject {
    
    @Published var routing: AuthSelectionView.Routing
    @Published var selectedEntity: EntityType
    
    var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    init(appState: Store<AppState>) {
        self.appState = appState
        
        _routing = .init(initialValue: appState[\.routing.authSelection])
        _selectedEntity = .init(initialValue: appState[\.data.selectedEntity])
        
        cancelBag.collect {
            $routing
                .removeDuplicates()
                .sink { appState[\.routing.authSelection] = $0 }
            
            $selectedEntity
                .removeDuplicates()
                .sink { appState[\.data.selectedEntity] = $0 }
            
            appState
                .map(\.routing.authSelection)
                .removeDuplicates()
                .assign(to: \.routing, on: self)
            
            appState
                .map(\.data.selectedEntity)
                .removeDuplicates()
                .assign(to: \.selectedEntity, on: self)
        }
    }
    
}
