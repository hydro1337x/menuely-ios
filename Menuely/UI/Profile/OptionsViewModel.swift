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
    
    @Published var routing: OptionsView.Routing
    @Published var logoutResult: Loadable<Discardable>
    
    var appState: Store<AppState>
    var cancelBag = CancelBag()
    var options: [OptionType] = [.updateProfile, .updatePassword, .updateEmail, .deleteAccount, .logout]
    var navigatableOptions: [OptionType] = [.updateProfile, .updatePassword, .updateEmail]
    
    // MARK: - Initialization
    init(appState: Store<AppState>, logoutResult: Loadable<Discardable> = .notRequested) {
        self.appState = appState
        
        _logoutResult = .init(initialValue: logoutResult)
        _routing = .init(initialValue: appState[\.routing.options])
        
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
    
    // MARK: - Routing
    func authSelectionViewRoute() {
        logoutResult.reset()
        appState[\.routing.profile.isOptionsSheetPresented] = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.appState[\.routing.root] = .auth
        }
    }
    
    func dismissAlertView() {
        self.appState[\.routing.alert.configuration] = nil
    }
    
    func logoutAlertView() {
        let configuration = AlertViewConfiguration(title: "Logout?",
                                                   message: "Are you sure you want to logout?",
                                                   primaryButtonTitle: "Logout",
                                                   secondaryButtonTitle: "Cancel",
                                                   primaryAction: logout,
                                                   secondaryAction: dismissAlertView)
        appState[\.routing.alert.configuration] = configuration
    }
    
    func deleteAccountAlertView() {
        let configuration = AlertViewConfiguration(title: "Delete account?",
                                                   message: "Are you sure you want to delete your account?",
                                                   primaryButtonTitle: "Delete",
                                                   secondaryButtonTitle: "Cancel",
                                                   primaryAction: nil,
                                                   secondaryAction: dismissAlertView)
        appState[\.routing.alert.configuration] = configuration
    }
}
