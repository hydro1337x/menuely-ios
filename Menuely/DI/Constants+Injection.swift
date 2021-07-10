//
//  Constants+Injection.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 10.07.2021..
//

import Resolver

extension Resolver {
    public static func registerConstants() {
        register(name: .font) { "Montserrat" }
    }
}

extension Resolver.Name {
    static var font = Self("font")
}
