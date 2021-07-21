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
        
        Spacer()
        
        Picker("Auth", selection: $viewModel.routing.selectedEntity) {
            Text("Restaurant").tag(EntityType.restaurant)
            Text("User").tag(EntityType.user)
        }
        .pickerStyle(SegmentedPickerStyle())
        .onChange(of: viewModel.routing, perform: { value in
            viewModel.routing = value
        })
        
        VStack {
            switch (viewModel.routing.selectedAuth, viewModel.routing.selectedEntity) {
            case (.login, .user): LoginView()
            case (.login, .restaurant): LoginView()
            case (.registration, .user): UserRegistrationView()
            case (.registration, .restaurant): RestaurantRegistrationView()
            }
        }
        
        Spacer()
    }
}

extension AuthSelectionView {
    struct Routing: Equatable {
        var selectedEntity: EntityType
        var selectedAuth: AuthType
    }
}

struct AuthSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AuthSelectionView()
    }
}
