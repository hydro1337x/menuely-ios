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
    var options: [OptionType] = [.editProfile, .changePassword, .deleteAccount, .logout]
    var navigatableOptions: [OptionType] = [.editProfile, .changePassword]
    
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
}
