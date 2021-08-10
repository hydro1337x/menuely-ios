//
//  EditUserProfileViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 23.07.2021..
//

import Foundation
import Resolver

class EditUserProfileViewModel: ObservableObject {
    // MARK: - Properties
    @Injected private var usersService: UsersServicing
    
    @Published var firstname: String = ""
    @Published var lastname: String = ""
    @Published var updateProfileResult: Loadable<Discardable>
    
    @Published var isFirstnameValid: Bool = false
    @Published var isLastnameValid: Bool = false
    var isFormValid: Bool {
        return isFirstnameValid && isLastnameValid
    }
    
    var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>, updateProfileResult: Loadable<Discardable> = .notRequested) {
        self.appState = appState
        
        _updateProfileResult = .init(initialValue: updateProfileResult)
    }
    
    // MARK: - Methods
    func updateUserProfile() {
        let bodyRequest = UpdateUserProfileBodyRequest(firstname: firstname, lastname: lastname)
        usersService.updateUserProfile(with: bodyRequest, updateProfileResult: loadableSubject(\.updateProfileResult))
    }
    
    func resetStates() {
        updateProfileResult.reset()
    }
    
    func loadFields() {
        guard let user = appState[\.data.authenticatedUser]?.user else { return }
        
        firstname = user.firstname
        lastname = user.lastname
    }
    
    // MARK: - Routing
    
    func errorView(with message: String?) {
        appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
    }
}
