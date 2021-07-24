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
    
    var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>, updateProfileResult: Loadable<Discardable> = .notRequested) {
        self.appState = appState
        
        _updateProfileResult = .init(initialValue: updateProfileResult)
    }
    
    // MARK: - Methods
    func updateUserProfile() {
        let userUpdateProfileRequestDTO = UserUpdateProfileRequestDTO(firstname: firstname, lastname: lastname)
        usersService.updateUserProfile(with: userUpdateProfileRequestDTO, updateProfileResult: loadableSubject(\.updateProfileResult))
    }
    
    func resetStates() {
        updateProfileResult.reset()
    }
    
    func loadFields() {
        guard let user = appState[\.data.authenticatedUser]?.user else { return }
        
        firstname = user.firstname
        lastname = user.lastname
    }
}
