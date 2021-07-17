//
//  LoginCoordinator.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 17.07.2021..
//

import Foundation

class LoginCoordinator: ObservableObject {
    // MARK: - Properties
    
    @Published var selection: EntityType
    
    private var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>) {
        _selection = .init(initialValue: appState[\.data.selectedEntity])
        
        self.cancelBag.collect {
            $selection
                .removeDuplicates()
                .sink { appState[\.data.selectedEntity] = $0 }
            
            appState
                .map(\.data.selectedEntity)
                .removeDuplicates()
                .assign(to: (\.selection), on: self)
        }
    }
    
    // MARK: - Methods
}
