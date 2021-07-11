//
//  RootCoordinator.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 11.07.2021..
//

import Foundation
import Combine

enum Tab {
    case home
    case person
    case restaurant
}

class RootCoordinator: ObservableObject {
    // MARK: - Properties
    @Published var tab: Tab = .home
    
    // MARK: - Initialization
    
    // MARK: - Methods
}
