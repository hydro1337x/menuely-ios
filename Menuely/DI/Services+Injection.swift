//
//  Services+Injection.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.07.2021..
//

import Resolver
import Alamofire

extension Resolver {
    public static func registerServices() {
        register { UsersService() as UsersServicing }
        register { AuthRequestInterceptor() as RequestInterceptor }
        register { NetworkClient(session: AF, interceptor: resolve()) as Networking }
    }
}
