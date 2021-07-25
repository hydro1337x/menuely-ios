//
//  OptionsViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.07.2021..
//

import Foundation
import Resolver

class OptionsViewModel: ObservableObject {
    // MARK: - Properties
    @Injected private var authService: AuthServicing
    @Injected private var usersService: UsersServicing
    @Injected private var restaurantsService: RestaurantsServicing
    
    @Published var routing: OptionsView.Routing
    @Published var logoutResult: Loadable<Discardable>
    @Published var deleteAccountResult: Loadable<Discardable>
    
    var appState: Store<AppState>
    var cancelBag = CancelBag()
    var options: [OptionType] = [.updateProfile, .updatePassword, .updateEmail, .deleteAccount, .logout]
    var navigatableOptions: [OptionType] = [.updateProfile, .updatePassword, .updateEmail]
    
    // MARK: - Initialization
    init(appState: Store<AppState>, logoutResult: Loadable<Discardable> = .notRequested, deleteAccountResult: Loadable<Discardable> = .notRequested) {
        self.appState = appState
        
        _routing = .init(initialValue: appState[\.routing.options])
        _logoutResult = .init(initialValue: logoutResult)
        _deleteAccountResult = .init(initialValue: deleteAccountResult)
        
        cancelBag.collect {
            $routing
                .removeDuplicates()
                .sink { appState[\.routing.options] = $0 }
            
            appState
                .map(\.routing.options)
                .removeDuplicates()
                .assign(to: \.routing, on: self)
        }
    }
    
    // MARK: - Methods
    func logout() {
        appState[\.routing.alert.configuration] = nil
        authService.logout(logoutResult: loadableSubject(\.logoutResult))
    }
    
    func deleteAccount() {
        appState[\.routing.alert.configuration] = nil
        
        switch appState[\.data.selectedEntity] {
        case .user: deleteUserAccount()
        case .restaurant: deleteRestaurantAccount()
        }
    }
    
    private func deleteUserAccount() {
        usersService.delete(deletionResult: loadableSubject(\.deleteAccountResult))
    }
    
    private func deleteRestaurantAccount() {
        restaurantsService.delete(deletionResult: loadableSubject(\.deleteAccountResult))
    }
    
    // MARK: - Routing
    
    /// Resets the whole AppState and return to the AuthSelectionView since it is the initial state
    func authSelectionView() {
        logoutResult.reset()
        deleteAccountResult.reset()
        appState.value.reset()
    }
    
    func dismissAlertView() {
        self.appState[\.routing.alert.configuration] = nil
    }
    
    func logoutAlertView() {
        let configuration = AlertViewConfiguration(title: "Logout?",
                                                   message: "Are you sure you want to logout?",
                                                   primaryAction: logout, primaryButtonTitle: "Logout",
                                                   secondaryAction: dismissAlertView, secondaryButtonTitle: "Cancel")
        appState[\.routing.alert.configuration] = configuration
    }
    
    func deleteAccountAlertView() {
        let configuration = AlertViewConfiguration(title: "Delete account?",
                                                   message: "Are you sure you want to delete your account?",
                                                   primaryAction: deleteAccount, primaryButtonTitle: "Delete",
                                                   secondaryAction: dismissAlertView, secondaryButtonTitle: "Cancel")
        appState[\.routing.alert.configuration] = configuration
    }
    
    func errorView(with message: String?) {
        appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
    }
}
