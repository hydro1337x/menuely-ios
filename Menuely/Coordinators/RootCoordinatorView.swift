//
//  RootCoordinatorView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 17.07.2021..
//

import SwiftUI

struct RootCoordinatorView: View {
    @InjectedObservedObject private var coordinator: RootCoordinator
    
    var body: some View {
        VStack {
            switch coordinator.coordinating {
            case .auth: AuthCoordinatorView()
            case .tabs: TabCoordinatorView()
            }
        }
    }
}

struct RootCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        RootCoordinatorView()
    }
}
