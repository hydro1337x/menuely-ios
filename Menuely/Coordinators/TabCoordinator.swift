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
    @Published var coordinating: Coordinating = .home
    
    // MARK: - Initialization
    
    // MARK: - Methods
}

extension TabCoordinator {
    enum Coordinating {
        case home
        case person
        case restaurant
    }
}
