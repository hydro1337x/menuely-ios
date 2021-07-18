//
//  RootCoordinator.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 17.07.2021..
//

import Foundation

class RootCoordinator: ObservableObject {
    // MARK: - Properties
    @Published var coordinating: Coordinating {
        didSet {
            print("RootCoordinator: ", coordinating)
        }
    }
    
    var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>) {
        _coordinating = .init(initialValue: appState[\.coordinating.root])
        
        cancelBag.collect {
            $coordinating
                .removeDuplicates()
                .sink { appState[\.coordinating.root] = $0 }
            
            appState
                .map(\.coordinating.root)
                .removeDuplicates()
                .assign(to: \.coordinating, on: self)
        }
    }
    
    // MARK: - Methods
}

extension RootCoordinator {
    enum Coordinating: Equatable {
        case tabs
        case auth
    }
}
