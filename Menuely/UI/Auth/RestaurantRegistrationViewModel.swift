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
    @Injected var appState: Store<AppState>
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var country: String = ""
    @Published var city: String = ""
    @Published var address: String = ""
    @Published var postalCode: String = ""
    
    var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init() {
        
    }
    
    // MARK: - Methods
}
