//
//  TabBarView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 20.07.2021..
//

import SwiftUI
import Resolver

struct TabBarView: View {
    
    @StateObject private var viewModel: TabBarViewModel = Resolver.resolve()
    @Injected var appState: Store<AppState>
    
    var body: some View {
        TabView(selection: $viewModel.tab) {
            
            switch viewModel.appState[\.data.selectedEntity] {
            case .user: userTabs
            case .restaurant: restaurantTabs
            }
            
            SearchListView()
            .tabItem { Label(
                title: { Text("Search") },
                icon: {
                    Image(.searchTab)
                }
            )}
            .tag(TabBarView.Routing.search)
            
            ProfileView()
            .tabItem { Label(
                title: { Text("Profile") },
                icon: {
                    Image(.profileTab)
                }
            )}
            .tag(TabBarView.Routing.profile)
        }
        .accentColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
    }
    
    @ViewBuilder
    private var userTabs: some View {
        ScanView()
        .tabItem { Label(
            title: { Text("Scan") },
            icon: {
                Image(.scanTab)
            }
        )}
        .tag(TabBarView.Routing.scan)
    }
    
    @ViewBuilder
    private var restaurantTabs: some View {
        MenusListView()
        .tabItem { Label(
            title: { Text("Menus") },
            icon: {
                Image(.menuTab)
            }
        )}
        .tag(TabBarView.Routing.menu)
    }
}

extension TabBarView {
    enum Routing {
        case scan
        case menu
        case search
        case profile
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
