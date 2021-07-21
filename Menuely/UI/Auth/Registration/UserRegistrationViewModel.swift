//
//  UserRegistrationViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 10.07.2021..
//

import Foundation
import Resolver
import Combine
import SwiftUI

class UserRegistrationViewModel: ObservableObject {
    // MARK: - Properties
    @Injected private var authService: AuthServicing
    @Injected var appState: Store<AppState>
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var firstname: String = ""
    @Published var lastname: String = ""
    @Published var registration: Loadable<Discardable>
    
    @Published var animateErrorView: Bool = false
    
    var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(registration: Loadable<Discardable> = .notRequested) {
        _registration = .init(initialValue: registration)
        $registration.sink { loadable in
            switch loadable {
            case .failed(_): self.animateErrorView = true
            default: self.animateErrorView = false
            }
        }
        .store(in: cancelBag)
    }
    
    // MARK: - Methods
    func register() {
        let userRegistrationRequestDTO = UserRegistrationRequestDTO(firstname: firstname, lastname: lastname, email: email, password: password)
        authService.registerUser(with: userRegistrationRequestDTO, registration: loadableSubject(\.registration))
    }
    
    // MARK: - Routing
    
    func loginViewRoute() {
        registration.reset()
        appState[\.routing.authSelection.selectedAuth] = .login
    }
}
