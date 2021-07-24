//
//  AuthSelectionView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 21.07.2021..
//

import SwiftUI

struct AuthSelectionView: View {
    @InjectedObservedObject private var viewModel: AuthSelectionViewModel
    
    var body: some View {
        
        Picker("Auth", selection: $viewModel.selectedEntity.animation()) {
            Text("Restaurant").tag(EntityType.restaurant)
            Text("User").tag(EntityType.user)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal, 30)
        
        VStack {
            switch (viewModel.routing.selectedAuth, viewModel.selectedEntity) {
            case (.login, .user): LoginView()
            case (.login, .restaurant): LoginView()
            case (.registration, .user): UserRegistrationView()
            case (.registration, .restaurant): RestaurantRegistrationView()
            }
        }
        .transition(.opacity)
    }
}

extension AuthSelectionView {
    struct Routing: Equatable {
        var selectedAuth: AuthType
    }
}

struct AuthSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AuthSelectionView()
    }
}
