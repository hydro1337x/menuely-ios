//
//  LoginCoordinatorView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 17.07.2021..
//

import SwiftUI
import Resolver

struct LoginCoordinatorView: View {
    
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
            .padding(.horizontal, 30)
            
            Group {
                switch coordinator.selection {
                default: LoginView()
                }
            }.padding(.top, 10)
        }
    }
}

struct LoginCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        LoginCoordinatorView()
    }
}
