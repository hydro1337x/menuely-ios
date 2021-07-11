//
//  AuthCoordinatorView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 11.07.2021..
//

import SwiftUI

struct AuthCoordinatorView: View {
    @InjectedObservedObject private var coordinator: AuthCoordinator
    
    var body: some View {
        AuthSelectionView()
    }
}

struct AuthCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        AuthCoordinatorView()
    }
}
