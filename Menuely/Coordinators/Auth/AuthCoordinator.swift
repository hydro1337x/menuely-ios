//
//  AuthCoordinator.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 11.07.2021..
//

import Foundation
import Combine

class AuthCoordinator: ObservableObject {
    // MARK: - Properties
    @Published var coordinating: Coordinating
    
    private var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>) {
        _coordinating = .init(initialValue: appState[\.coordinating.auth])
        
        cancelBag.collect {
            $coordinating
                .removeDuplicates()
                .sink { appState[\.coordinating.auth] = $0 }
            
            appState
                .map(\.coordinating.auth)
                .removeDuplicates()
                .assign(to: \.coordinating, on: self)
        }
    }
    
    // MARK: - Methods
}

extension AuthCoordinator {
    enum Coordinating: Equatable {
        case login
        case registration
    }
}

