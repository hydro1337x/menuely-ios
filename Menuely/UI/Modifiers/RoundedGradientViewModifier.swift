//
//  RoundedGradientViewModifier.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 16.08.2021..
//

import SwiftUI

struct RoundedGradientViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3146468997, green: 0.7964186072, blue: 0.5054938793, alpha: 1)), Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1))]), startPoint: .top, endPoint: .bottom))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 1)
    }
}
