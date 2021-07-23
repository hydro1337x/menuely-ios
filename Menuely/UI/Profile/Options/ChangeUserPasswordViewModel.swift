//
//  ChangeUserPasswordViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 23.07.2021..
//

import Foundation
import Combine
import Resolver

class ChangeUserPasswordViewModel: ObservableObject {
    // MARK: - Properties
    @Injected private var authService: AuthServicing
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var country: String = ""
    @Published var city: String = ""
    @Published var address: String = ""
    @Published var postalCode: String = ""
    
    var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>) {
        self.appState = appState
    }
    
    // MARK: - Methods
}
