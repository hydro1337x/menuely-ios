//
//  RootCoordinatorView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 11.07.2021..
//

import SwiftUI

struct RootCoordinatorView: View {
    @InjectedObservedObject private var coordinator: RootCoordinator
    
    var body: some View {
        TabView(selection: $coordinator.tab) {
            
            AuthCoordinatorView()
                .tabItem { Label(
                    title: { Text("Scan") },
                    icon: {
                        Image(.scanTab)
                    }
                )}
                .tag(Tab.home)
            
            Text("Search")
                .tabItem { Label(
                    title: { Text("Search") },
                    icon: {
                        Image(.searchTab)
                    }
                )}
                .tag(Tab.person)
            
            Text("Profile")
                .tabItem { Label(
                    title: { Text("Profile") },
                    icon: {
                        Image(.profileTab)
                    }
                )}
                .tag(Tab.restaurant)
        }
        .accentColor(Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1)))
    }
}

struct RootCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        RootCoordinatorView()
    }
}
