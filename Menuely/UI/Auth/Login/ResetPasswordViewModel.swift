//
//  ResetPasswordViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 16.08.2021..
//

import Foundation
import Resolver

extension ResetPasswordView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        @Injected private var authService: AuthServicing
        @Injected var appState: Store<AppState>
        
        @Published var resetPasswordResult: Loadable<Discardable>
        @Published var email: String = ""
        
        @Published var isEmailValid: Bool = false
        
        var cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(resetPasswordResult: Loadable<Discardable> = .notRequested) {
            _resetPasswordResult = .init(initialValue: resetPasswordResult)
        }
        
        // MARK: - Methods
        func resetPassword() {
            let bodyRequest = ResetPasswordBodyRequest(email: email)
            switch appState[\.data.selectedEntity] {
            case .user: authService.resetUserPassword(with: bodyRequest, resetPasswordResult: loadableSubject(\.resetPasswordResult))
            case .restaurant: authService.resetRestaurantPassword(with: bodyRequest, resetPasswordResult: loadableSubject(\.resetPasswordResult))
            }
        }
        
        
        // MARK: - Routing
        func dismiss() {
            appState[\.routing.login.isResetPasswordSheetPresented] = nil
        }
        
        func errorView(with message: String?) {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
        }
        
        func alertView() {
            let configuration = AlertViewConfiguration(title: "Password reset successfully", message: "A newly generated password has been sent to the provided email", primaryAction: {
                self.appState[\.routing.alert.configuration] = nil
                self.dismiss()
            }, primaryButtonTitle: "OK", secondaryAction: nil, secondaryButtonTitle: nil)
            appState[\.routing.alert.configuration] = configuration
        }
    }
}
