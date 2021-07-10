//
//  ScaledFontModifier.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 10.07.2021..
//

import SwiftUI
import Resolver

private struct ScaledFontModifier: ViewModifier {
    
    @Injected var fontScaleUtility: FontScaleUtility
    let textStyle: Font.TextStyle

    func body(content: Content) -> some View {
        content
            .font(fontScaleUtility.font(forTextStyle: textStyle))
    }
}

extension View {
    public func scaledFont(_ textStyle: Font.TextStyle = .body) -> some View {
        let modifier = modifier(ScaledFontModifier(textStyle: textStyle))
        return modifier
    }
}
