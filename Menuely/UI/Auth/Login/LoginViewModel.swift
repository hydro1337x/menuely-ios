//
//  LoginViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 11.07.2021..
//

import Foundation
import Resolver
import Combine

import UIKit
class LoginViewModel: ObservableObject {
    // MARK: - Properties
    @Injected private var authService: AuthServicing
    
    @Published var routing: AuthSelectionView.Routing
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var loginResult: Loadable<Discardable>
    
    @Published private var authenticatedUser: Loadable<AuthenticatedUser>
    @Published private var authenticatedRestaurant: Loadable<AuthenticatedRestaurant>
    
    var appState: Store<AppState>
    let cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>, loginResult: Loadable<Discardable> = .notRequested, authenticatedUser: Loadable<AuthenticatedUser> = .notRequested, authenticatedRestaurant: Loadable<AuthenticatedRestaurant> = .notRequested) {
        self.appState = appState
        
        _routing = .init(initialValue: appState[\.routing.authSelection])
        _loginResult = .init(initialValue: loginResult)
        _authenticatedUser = .init(initialValue: authenticatedUser)
        _authenticatedRestaurant = .init(initialValue: authenticatedRestaurant)
        
        cancelBag.collect {
            $routing
                .removeDuplicates()
                .sink { appState[\.routing.authSelection] = $0 }
            
            appState
                .map(\.routing.authSelection)
                .removeDuplicates()
                .assign(to: \.routing, on: self)
        }
        
        $authenticatedUser.map { loadable -> Loadable<Discardable> in
            switch loadable {
            case .notRequested:
                return Loadable<Discardable>.notRequested
                
            case .isLoading(_, let cancelBag):
                return Loadable<Discardable>.isLoading(last: Discardable(), cancelBag: cancelBag)
                
            case .loaded(_):
                return Loadable<Discardable>.loaded(Discardable())
                
            case .failed(let error):
                return Loadable<Discardable>.failed(error)
            }
        }
        .assign(to: \.loginResult, on: self)
        .store(in: cancelBag)
        
        $authenticatedRestaurant.map { loadable -> Loadable<Discardable> in
            switch loadable {
            case .notRequested:
                return Loadable<Discardable>.notRequested
                
            case .isLoading(_, let cancelBag):
                return Loadable<Discardable>.isLoading(last: Discardable(), cancelBag: cancelBag)
                
            case .loaded(_):
                return Loadable<Discardable>.loaded(Discardable())
                
            case .failed(let error):
                return Loadable<Discardable>.failed(error)
            }
        }
        .assign(to: \.loginResult, on: self)
        .store(in: cancelBag)
    }
    
    // MARK: - Methods
    func login() {
        let loginRequestDTO = LoginRequestDTO(email: email, password: password)
        switch appState[\.data.selectedEntity] {
        case .user: loginUser(with: loginRequestDTO)
        case .restaurant: loginRestaurant(with: loginRequestDTO)
        }
    }
    
    private func loginUser(with loginRequestDTO: LoginRequestDTO) {
        authService.loginUser(with: loginRequestDTO, authenticatedUser: loadableSubject(\.authenticatedUser))
    }
    
    private func loginRestaurant(with loginRequestDTO: LoginRequestDTO) {
        authService.loginRestaurant(with: loginRequestDTO, authenticatedRestaurant: loadableSubject(\.authenticatedRestaurant))
    }
    
    // MARK: - Routing
    func registrationViewRoute() {
        routing.selectedAuth = .registration
    }
    
    func tabBarViewRoute() {
        resetStates()
        email = ""
        password = ""
        appState[\.routing.root] = .tabs
    }
    
    func resetStates() {
        loginResult.reset()
    }
}
