//
//  AuthSelectionView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 09.07.2021..
//

import SwiftUI
import Resolver

struct AuthSelectionView: View {
    
    enum AuthState {
        case registration
        case login
    }
    
    @Injected private var appState: Store<AppState>
    
    @State private var authState: AuthState = .login
    @State private var entityType: EntityType = .user
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Entity", selection: $authState) {
                    Text("Login").tag(AuthState.login)
                    Text("Registration").tag(AuthState.registration)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Picker("Auth", selection: $entityType) {
                    Text("Restaurant").tag(EntityType.restaurant)
                    Text("User").tag(EntityType.user)
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: entityType, perform: { value in
                    appState[\.data.selectedEntity] = value
                })
                
                switch (authState, entityType) {
                case (.login, .user): LoginView()
                case (.login, .restaurant): LoginView()
                case (.registration, .user): UserRegistrationView()
                case (.registration, .restaurant): RestaurantRegistrationView()
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
        }
    }
}

struct AuthSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AuthSelectionView()
    }
}
