//
//  RootView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 20.07.2021..
//

import SwiftUI

struct RootView: View {
    @InjectedObservedObject private var viewModel: RootViewModel
    
    init() {
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)]
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
