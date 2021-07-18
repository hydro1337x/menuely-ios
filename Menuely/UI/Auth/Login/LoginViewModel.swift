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
    @Injected var appState: Store<AppState>
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var loginResult: Loadable<Discardable>
    
    @Published private var authenticatedUser: Loadable<AuthenticatedUser>
    @Published private var authenticatedRestaurant: Loadable<AuthenticatedRestaurant>
    
    @Published var animateErrorView: Bool = false
    
    let cancelBag = CancelBag()
    @Injected private var usersService: UsersServicing
    
    // MARK: - Initialization
    init(loginResult: Loadable<Discardable> = .notRequested, authenticatedUser: Loadable<AuthenticatedUser> = .notRequested, authenticatedRestaurant: Loadable<AuthenticatedRestaurant> = .notRequested) {
        _loginResult = .init(initialValue: loginResult)
        _authenticatedUser = .init(initialValue: authenticatedUser)
        _authenticatedRestaurant = .init(initialValue: authenticatedRestaurant)
        
        $authenticatedUser.map { loadable -> Loadable<Discardable> in
            switch loadable {
            case .notRequested:
                self.animateErrorView = false
                return Loadable<Discardable>.notRequested
                
            case .isLoading(_, let cancelBag):
                self.animateErrorView = false
                return Loadable<Discardable>.isLoading(last: Discardable(), cancelBag: cancelBag)
                
            case .loaded(_):
                self.animateErrorView = false
                return Loadable<Discardable>.loaded(Discardable())
                
            case .failed(let error):
                self.animateErrorView = true
                return Loadable<Discardable>.failed(error)
            }
        }
        .assign(to: \.loginResult, on: self)
        .store(in: cancelBag)
        
        $authenticatedRestaurant.map { loadable -> Loadable<Discardable> in
            switch loadable {
            case .notRequested:
                self.animateErrorView = false
                return Loadable<Discardable>.notRequested
                
            case .isLoading(_, let cancelBag):
                self.animateErrorView = false
                return Loadable<Discardable>.isLoading(last: Discardable(), cancelBag: cancelBag)
                
            case .loaded(_):
                self.animateErrorView = false
                return Loadable<Discardable>.loaded(Discardable())
                
            case .failed(let error):
                self.animateErrorView = true
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
}
