//
//  ProfileViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.07.2021..
//

import Foundation
import Resolver

class ProfileViewModel: ObservableObject {
    // MARK: - Properties
    @Published var routing: ProfileView.Routing
    
    var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>) {
        self.appState = appState
        
        _routing = .init(initialValue: appState[\.routing.profile])
        
        cancelBag.collect {
            $routing
                .removeDuplicates()
                .sink { appState[\.routing.profile] = $0 }
            
            appState
                .map(\.routing.profile)
                .removeDuplicates()
                .assign(to: \.routing, on: self)
        }
    }
    
    // MARK: - Methods
    
    // MARK: - Routing
    func resetNavigationStack() {
        appState[\.routing.options.details] = nil
    }
}
