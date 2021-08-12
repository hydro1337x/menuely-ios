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
    @Published var logoutDeleteResult: Loadable<Discardable>
    @Published var quitEmployerResult: Loadable<Discardable>
    
    var appState: Store<AppState>
    var cancelBag = CancelBag()
    var options: [OptionType] = [.updateProfile, .updatePassword, .updateEmail, .deleteAccount, .logout]
    var navigatableOptions: [OptionType] = [.updateProfile, .updatePassword, .updateEmail]
    
    // MARK: - Initialization
    init(appState: Store<AppState>, logoutDeleteResult: Loadable<Discardable> = .notRequested, quitEmployerResult: Loadable<Discardable> = .notRequested) {
        self.appState = appState
        
        _routing = .init(initialValue: appState[\.routing.options])
        _logoutDeleteResult = .init(initialValue: logoutDeleteResult)
        _quitEmployerResult = .init(initialValue: quitEmployerResult)
        
        cancelBag.collect {
            $routing
                .removeDuplicates()
                .sink { appState[\.routing.options] = $0 }
            
            appState
                .map(\.routing.options)
                .removeDuplicates()
                .assign(to: \.routing, on: self)
        }
        
        appendOptionalOptions()
    }
    
    // MARK: - Methods
    func appendOptionalOptions() {
        if appState[\.data.authenticatedUser]?.user.employer != nil {
            options.append(.quitEmployer)
        }
        
        if appState[\.data.selectedEntity] == .user {
            options.append(.userOrders)
        }
    }
    func logout() {
        appState[\.routing.alert.configuration] = nil
        authService.logout(logoutResult: loadableSubject(\.logoutDeleteResult))
    }
    
    func deleteAccount() {
        appState[\.routing.alert.configuration] = nil
        
        switch appState[\.data.selectedEntity] {
        case .user: deleteUserAccount()
        case .restaurant: deleteRestaurantAccount()
        }
    }
    
    private func deleteUserAccount() {
        usersService.delete(deletionResult: loadableSubject(\.logoutDeleteResult))
    }
    
    private func deleteRestaurantAccount() {
        restaurantsService.delete(deletionResult: loadableSubject(\.logoutDeleteResult))
    }
    
    private func quitEmployer() {
        usersService.quitEmployer(quitEmployerResult: loadableSubject(\.quitEmployerResult))
    }
    
    // MARK: - Routing
    
    /// Resets the whole AppState and return to the AuthSelectionView since it is the initial state
    func authSelectionView() {
        logoutDeleteResult.reset()
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
    
    func quitEmployerAlertView() {
        let configuration = AlertViewConfiguration(title: "Quit employer?",
                                                   message: "Are you sure you want to quit your employer?",
                                                   primaryAction: quitEmployer, primaryButtonTitle: "Quit",
                                                   secondaryAction: dismissAlertView, secondaryButtonTitle: "Cancel")
        appState[\.routing.alert.configuration] = configuration
    }
    
    func errorView(with message: String?) {
        appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
    }
     
    func dismissAndUpdateProfileView() {
        dismissAlertView()
        appState[\.data.updateUserProfileView] = true
        appState[\.routing.profile.isOptionsSheetPresented] = false
    }
    
    func dismissAndShowUserOrdersListView() {
        appState[\.routing.profile.isOptionsSheetPresented] = false
        appState[\.routing.profile.userOrdersList] = true
    }
}
