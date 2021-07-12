//
//  GradientButton.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 10.07.2021..
//

import SwiftUI

struct RoundedGradientButtonStyle: ButtonStyle {
    
    let startGradient = LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3146468997, green: 0.7964186072, blue: 0.5054938793, alpha: 1)), Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1))]), startPoint: .top, endPoint: .bottom)
    let endGradient = LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3146468997, green: 0.7964186072, blue: 0.5054938793, alpha: 1)), Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1))]), startPoint: UnitPoint(x: 1, y: 0.5), endPoint: UnitPoint(x: 0, y: 0.5))
    
    func makeBody(configuration: Configuration) -> some View {
        
        return configuration.label
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(configuration.isPressed ? endGradient : startGradient)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: configuration.isPressed ? 1 : 3)
            .scaleEffect(configuration.isPressed ? 0.99 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
