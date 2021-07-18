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
    @Injected var appState: Store<AppState>
    @Injected private var authService: AuthServicing
    
    @Published var logoutResult: Loadable<Discardable>
    @Published var animateErrorView: Bool = false
    
    var cancelBag = CancelBag()
    var options: [OptionType] = [.editProfile, .changePassword, .deleteAccount, .logout]
    
    // MARK: - Initialization
    init(logoutResult: Loadable<Discardable> = .notRequested) {
        _logoutResult = .init(initialValue: logoutResult)
        
        $logoutResult.sink { loadable in
            print(loadable)
            switch loadable {
            case .failed(_): self.animateErrorView = true
            default: self.animateErrorView = false
            }
        }
        .store(in: cancelBag)
    }
    
    // MARK: - Methods
    func logout() {
        authService.logout(logoutResult: loadableSubject(\.logoutResult))
    }
    
    func coordinateToAuthView() {
        appState[\.coordinating.profile] = .initial
        
        appState[\.coordinating.root] = .auth
    }
    
    func coordinateToOptionDetailsView(with option: OptionType) {
        appState[\.coordinating.options] = .details(optionType: option)
    }
}
