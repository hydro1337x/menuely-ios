//
//  Utilities+Injection.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 10.07.2021..
//

import Resolver

extension Resolver {
    public static func registerUtilities() {
        register { FontScaleUtility(fontName: resolve(name: .font)) }
    }
}
