//
//  Utilities+Injection.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 10.07.2021..
//

import Resolver

extension Resolver {
    public static func registerUtilities() {
        register { DateUtility() }.scope(.shared)
        register { MultipartFormatter() }.scope(.shared)
    }
}
