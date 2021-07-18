//
//  ProfileCoordinatorView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.07.2021..
//

import SwiftUI

struct ProfileCoordinatorView: View {
    
    @InjectedObservedObject private var coordinator: ProfileCoordinator
    
    var body: some View {
        ProfileView()
            .sheet(isPresented: coordinator.coordinating == .options ? .constant(true) : .constant(false)) {
                coordinator.coordinating = .initial
            } content: {
                OptionsCoordinatorView()
            }

    }
}

struct ProfileCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCoordinatorView()
    }
}
