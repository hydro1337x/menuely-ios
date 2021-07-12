//
//  LoginViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 11.07.2021..
//

import Foundation
import Resolver
import Combine

class LoginViewModel: ObservableObject {
    // MARK: - Properties
    @Injected private var authService: AuthServicing
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    // MARK: - Initialization
    
    
    // MARK: - Methods
    
}
