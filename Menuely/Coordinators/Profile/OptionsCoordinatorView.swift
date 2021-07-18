//
//  OptionsCoordinatorView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.07.2021..
//

import SwiftUI

struct OptionsCoordinatorView: View {
    @InjectedObservedObject private var coordinator: OptionsCoordinator
    
    var body: some View {
        NavigationView {
            switch coordinator.coordinating {
            case .initial: OptionsView()
            case .details(let option): OptionsView().navigation(isActive: coordinator.coordinating == .initial ? .constant(false) : .constant(true), destination: {
                Text("View type: \(option.rawValue)")
                    .onDisappear {
                        coordinator.coordinating = .initial
                    }
            })
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct OptionsCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsCoordinatorView()
    }
}
