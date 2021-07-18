//
//  RootCoordinator.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 11.07.2021..
//

import Foundation
import Combine

class TabCoordinator: ObservableObject {
    // MARK: - Properties
    @Published var coordinating: Coordinating = .scan
    
    // MARK: - Initialization
    
    // MARK: - Methods
}

extension TabCoordinator {
    enum Coordinating {
        case scan
        case search
        case profile
    }
}
