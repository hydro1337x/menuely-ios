//
//  SelectionCardButtonStyle.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 10.07.2021..
//

import SwiftUI

struct SelectionCardButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color(#colorLiteral(red: 0.9646247029, green: 0.9647596478, blue: 0.9645821452, alpha: 1)).opacity(1) : Color(#colorLiteral(red: 0.9646247029, green: 0.9647596478, blue: 0.9645821452, alpha: 1)).opacity(0.9))
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.99 : 1)
            .shadow(radius: configuration.isPressed ? 1 : 2)
            .animation(.easeInOut(duration: 0.2))
    }
}
