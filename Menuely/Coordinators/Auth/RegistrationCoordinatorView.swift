//
//  RegistrationCoordinatorView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 17.07.2021..
//

import SwiftUI
import Resolver

struct RegistrationCoordinatorView: View {
    
    @InjectedObservedObject private var coordinator: RegistrationCoordinator
    
    var body: some View {
        VStack {
            
            Picker("Auth", selection: $coordinator.selection) {
                Text("Restaurant").tag(EntityType.restaurant)
                Text("User").tag(EntityType.user)
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: coordinator.selection, perform: { value in
                coordinator.selection = value
            })
            
            Group {
                switch (coordinator.selection) {
                case .user: UserRegistrationView()
                case .restaurant: RestaurantRegistrationView()
                }
            }
        }
        .padding(.horizontal, 30)
    }
}

struct RegistrationCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationCoordinatorView()
    }
}
