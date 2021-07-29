//
//  UpdateEmailViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 25.07.2021..
//

import Foundation
import Resolver

class UpdateEmailViewModel: ObservableObject {
    // MARK: - Properties
    @Injected private var usersService: UsersServicing
    @Injected private var restaurantsService: RestaurantsServicing
    
    @Published var email: String = ""
    @Published var updateEmailResult: Loadable<Discardable>
    
    var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>, updateEmailResult: Loadable<Discardable> = .notRequested) {
        self.appState = appState
        
        _updateEmailResult = .init(initialValue: updateEmailResult)
    }
    
    // MARK: - Methods
    func updateEmail() {
        let bodyRequest = UpdateEmailBodyRequest(email: email)
        switch appState[\.data.selectedEntity] {
        case .user: updateUserEmail(with: bodyRequest)
        case .restaurant: updateRestaurantEmail(with: bodyRequest)
        }
    }
    
    func updateUserEmail(with bodyRequest: UpdateEmailBodyRequest) {
        usersService.updateUserEmail(with: bodyRequest, updateEmailResult: loadableSubject(\.updateEmailResult))
    }
    
    func updateRestaurantEmail(with bodyRequest: UpdateEmailBodyRequest) {
        restaurantsService.updateRestaurantEmail(with: bodyRequest, updateEmailResult: loadableSubject(\.updateEmailResult))
    }
    
    func updateProfile() {
        switch appState[\.data.selectedEntity] {
        case .user: appState[\.data.updateUserProfileView] = true
        case .restaurant: appState[\.data.updateRestaurantProfileView] = true
        }
        
    }
    
    func resetStates() {
        email = ""
        updateEmailResult.reset()
    }
    
    // MARK: - Routing
    
    func errorView(with message: String?) {
        appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
    }
    
    // FIXME: - Change alert view to dynamically change layout based on passed parameters
    func alertView() {
        appState[\.routing.alert.configuration] = AlertViewConfiguration(title: "Email successfully changed", message: "A new verification has been send to your newly changed email", primaryAction: {
            self.appState[\.routing.alert.configuration] = nil
            self.appState[\.routing.options.details] = nil
        }, primaryButtonTitle: "OK", secondaryAction: nil, secondaryButtonTitle: nil)
    }
}
