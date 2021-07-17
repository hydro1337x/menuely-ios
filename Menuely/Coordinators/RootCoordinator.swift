//
//  RootCoordinator.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 17.07.2021..
//

import Foundation

class RootCoordinator: ObservableObject {
    // MARK: - Properties
    @Published var coordinating: Coordinating
    
    // MARK: - Initialization
    init(appState: Store<AppState>) {
        _coordinating = .init(initialValue: appState[\.coordinating.root])
    }
    
    // MARK: - Methods
}

extension RootCoordinator {
    enum Coordinating: Equatable {
        case tabs
        case auth
    }
}
