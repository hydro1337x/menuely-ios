//
//  TabBarView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 20.07.2021..
//

import SwiftUI
import Resolver

struct TabBarView: View {
    
    @InjectedObservedObject private var viewModel: TabBarViewModel
    @Injected var appState: Store<AppState>
    @State var text = ""
    
    var body: some View {
        TabView(selection: $viewModel.tab) {
            
            ScanView()
            .tabItem { Label(
                title: { Text("Scan") },
                icon: {
                    Image(.scanTab)
                }
            )}
            .tag(TabBarView.Routing.scan)
            
            NavigationView {
                MenusListView()
            }
            .tabItem { Label(
                title: { Text("Search") },
                icon: {
                    Image(.searchTab)
                }
            )}
            .tag(TabBarView.Routing.search)
            
            NavigationView {
                ProfileView()
            }
            .tabItem { Label(
                title: { Text("Profile") },
                icon: {
                    Image(.profileTab)
                }
            )}
            .tag(TabBarView.Routing.profile)
        }
        .accentColor(Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1)))
        .animation(.easeInOut)
        .transition(.fade)
    }
}

extension TabBarView {
    enum Routing {
        case scan
        case search
        case profile
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
