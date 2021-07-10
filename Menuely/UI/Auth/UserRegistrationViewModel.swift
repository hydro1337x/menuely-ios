//
//  UserRegistrationViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 10.07.2021..
//

import Foundation
import Combine

class UserRegistrationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var firstname: String = ""
    @Published var lastname: String = ""
    
    init() {
        print("Init: ", self)
    }
}
