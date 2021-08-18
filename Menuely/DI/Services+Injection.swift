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
        register { AuthRequestInterceptor() as RequestInterceptor }
        register { NetworkClient(session: AF, interceptor: resolve()) as Networking }
        register { UsersService() as UsersServicing }
        register { RestaurantsService() as RestaurantsServicing }
        register { AuthService() as AuthServicing }
        register { MenusService() as MenusServicing }
        register { CategoriesService() as CategoriesServicing }
        register { ProductsService() as ProductsServicing }
        register { CartService(appState: resolve()) as CartServicing }.scope(.shared)
        register { OrdersService() as OrdersServicing }
        register { InvitationsService() as InvitationsServicing }
    }
}
