//
//  RestaurantRegistrationViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 11.07.2021..
//

import SwiftUI
import Resolver

class RestaurantRegistrationViewModel: ObservableObject {
    // MARK: - Properties
    @Injected private var authService: AuthServicing
    @Injected var appState: Store<AppState>
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var country: String = ""
    @Published var city: String = ""
    @Published var address: String = ""
    @Published var postalCode: String = ""
    @Published var registration: Loadable<Discardable>
    
    var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(registration: Loadable<Discardable> = .notRequested) {
        _registration = .init(initialValue: registration)
    }
    
    // MARK: - Methods
    func register() {
        let restaurantRegistrationRequestDTO = RestaurantRegistrationRequestDTO(email: email,
                                                                                password: password,
                                                                                description: description,
                                                                                name: name,
                                                                                country: country,
                                                                                city: city,
                                                                                address: address,
                                                                                postalCode: postalCode)
        authService.registerRestaurant(with: restaurantRegistrationRequestDTO, registration: loadableSubject(\.registration))
    }
    
    func resetStates() {
        registration.reset()
    }
    
    // MARK: - Routing
    func loginView() {
        resetStates()
        appState[\.routing.authSelection.selectedAuth] = .login
    }
    
    func errorView(with message: String?) {
        appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
    }
}
