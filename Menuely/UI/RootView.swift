//
//  RootView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 20.07.2021..
//

import SwiftUI

struct RootView: View {
    @InjectedObservedObject private var viewModel: RootViewModel
    
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
