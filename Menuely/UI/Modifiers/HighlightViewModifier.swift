//
//  HighlightViewModifier.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 05.08.2021..
//

import SwiftUI

struct HightlightViewModifier: ViewModifier {
    @State var isHighlighted: Bool = false
    
    func body(content: Content) -> some View {
        content
            .overlay(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)).opacity(isHighlighted ? 0.6 : 0))
            .onHover { hovering in
                isHighlighted = hovering
            }
    }
}
