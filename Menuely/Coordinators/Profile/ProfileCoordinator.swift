//
//  ProfileCoordinator.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.07.2021..
//

import Foundation

class ProfileCoordinator: ObservableObject {
    // MARK: - Properties
    @Published var coordinating: Coordinating
    
    var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>) {
        _coordinating = .init(initialValue: appState[\.coordinating.profile])
        
        cancelBag.collect {
            $coordinating
                .removeDuplicates()
                .sink { appState[\.coordinating.profile] = $0 }
            
            appState
                .map(\.coordinating.profile)
                .removeDuplicates()
                .assign(to: \.coordinating, on: self)
        }
    }
    
    // MARK: - Methods
}

extension ProfileCoordinator {
    enum Coordinating: Equatable {
        case initial
        case options
    }
}
