//
//  ScaledFont.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 10.07.2021..
//

import SwiftUI

public struct FontScaleUtility {
    // MARK: - Types
    enum StyleKey: String, Decodable {
        case largeTitle, title, title2, title3
        case headline, subheadline, body, callout
        case footnote, caption, caption2
    }

    struct FontDescription: Decodable {
        let fontSize: CGFloat
        let fontName: String
    }

    typealias StyleDictionary = [StyleKey.RawValue: FontDescription]
    
    // MARK: - Properties
    var styleDictionary: StyleDictionary?
    
    // MARK: - Initialization
    init(fontName: String, bundle: Bundle = .main) {
        if let url = bundle.url(forResource: fontName, withExtension: "plist"),
           let data = try? Data(contentsOf: url)
        {
            let decoder = PropertyListDecoder()
            styleDictionary = try? decoder.decode(StyleDictionary.self, from: data)
        }
    }
    
    // MARK: - Methods
    func font(forTextStyle textStyle: Font.TextStyle) -> Font {
        guard let styleKey = StyleKey(textStyle),
              let fontDescription = styleDictionary?[styleKey.rawValue]
        else {
            return Font.system(textStyle)
        }
        
        let font = Font.custom(fontDescription.fontName, size: fontDescription.fontSize, relativeTo: textStyle)
        
        return font
    }
}

extension FontScaleUtility.StyleKey {
    init?(_ textStyle: Font.TextStyle) {
        switch textStyle {
        case .largeTitle: self = .largeTitle
        case .title: self = .title
        case .title2: self = .title2
        case .title3: self = .title3
        case .headline: self = .headline
        case .subheadline: self = .subheadline
        case .body: self = .body
        case .callout: self = .callout
        case .footnote: self = .footnote
        case .caption: self = .caption
        case .caption2: self = .caption2
        @unknown default: return nil
        }
    }
}
