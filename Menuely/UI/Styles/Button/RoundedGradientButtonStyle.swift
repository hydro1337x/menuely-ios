//
//  GradientButton.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 10.07.2021..
//

import SwiftUI

struct RoundedGradientButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) var isEnabled
    
    let cornerRadius: CGFloat = 10
    let startGradient = LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3146468997, green: 0.7964186072, blue: 0.5054938793, alpha: 1)), Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1))]), startPoint: .top, endPoint: .bottom)
    let endGradient = LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3146468997, green: 0.7964186072, blue: 0.5054938793, alpha: 1)), Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1))]), startPoint: UnitPoint(x: 1, y: 0.5), endPoint: UnitPoint(x: 0, y: 0.5))
    let disabledGradient = LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9646247029, green: 0.9647596478, blue: 0.9645821452, alpha: 1)), Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1))]), startPoint: UnitPoint(x: 1, y: 0.5), endPoint: UnitPoint(x: 0, y: 0.5))
    
    func makeBody(configuration: Configuration) -> some View {
        
        return configuration.label
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(background(isPressed: configuration.isPressed))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(radius: configuration.isPressed ? 1 : 3)
            .scaleEffect(configuration.isPressed ? 0.99 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
    
    func background(isPressed: Bool) -> LinearGradient {
        if isEnabled {
            return isPressed ? endGradient : startGradient
        } else {
            return disabledGradient
        }
    }
}
