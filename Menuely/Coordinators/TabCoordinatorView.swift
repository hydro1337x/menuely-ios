//
//  TabCoordinatorView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 11.07.2021..
//

import SwiftUI

struct TabCoordinatorView: View {
    @InjectedObservedObject private var coordinator: TabCoordinator
    
    var body: some View {
        TabView(selection: $coordinator.coordinating) {
            
            Text("Scan view")
            .tabItem { Label(
                title: { Text("Scan") },
                icon: {
                    Image(.scanTab)
                }
            )}
            .tag(TabCoordinator.Coordinating.scan)
            
            Text("Search view")
            .tabItem { Label(
                title: { Text("Search") },
                icon: {
                    Image(.searchTab)
                }
            )}
            .tag(TabCoordinator.Coordinating.search)
            
            NavigationView {
                ProfileCoordinatorView()
            }
            .tabItem { Label(
                title: { Text("Profile") },
                icon: {
                    Image(.profileTab)
                }
            )}
            .tag(TabCoordinator.Coordinating.profile)
        }
        .accentColor(Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1)))
    }
}

struct TabCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        TabCoordinatorView()
    }
}
