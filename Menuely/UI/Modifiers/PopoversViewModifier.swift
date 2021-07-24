//
//  PopoversViewModifier.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 24.07.2021..
//

import SwiftUI

struct PopoversViewModifier: ViewModifier {
        func body(content: Content) -> some View {
            ZStack {
                content
                ActivityIndicatorView()
                ErrorView()
                AlertView()
            }
        }
}
