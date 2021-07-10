//
//  RootViewModifier.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 09.07.2021..
//

import SwiftUI
import Resolver

struct RootViewAppearance: ViewModifier {
    
    @InjectedObservedObject private(set) var viewModel: ViewModel
    
    func body(content: Content) -> some View {
        content
            .blur(radius: viewModel.isActive ? 0 : 10)
    }
}

extension RootViewAppearance {
    class ViewModel: ObservableObject {
        @Injected private(set) var appState: Store<AppState>
        @Published var isActive: Bool = false {
            didSet {
                print(isActive)
            }
        }
        private let cancelBag = CancelBag()
        
        init() {
            appState.map(\.application.isActive)
                .removeDuplicates()
                .assign(to: \.isActive, on: self)
                .store(in: cancelBag)
        }
    }
}
