//
//  RootView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 20.07.2021..
//

import SwiftUI
import Resolver

struct RootView: View {
    @StateObject private var viewModel: RootViewModel = Resolver.resolve()
    
    init() {
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    var body: some View {
        VStack {
            switch viewModel.routing {
            case .auth: AuthSelectionView()
            case .tabs: TabBarView()
            }
        }
    }
}

extension RootView {
    enum Routing {
        case auth
        case tabs
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
