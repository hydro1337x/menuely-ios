//
//  UpdatePasswordViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 24.07.2021..
//

import Foundation
import Resolver

class UpdatePasswordViewModel: ObservableObject {
    // MARK: - Properties
    @Injected private var usersService: UsersServicing
    @Injected private var restaurantsService: RestaurantsServicing
    
    @Published var oldPassword: String = ""
    @Published var newPassword: String = ""
    @Published var repeatedNewPassword: String = ""
    @Published var updatePasswordResult: Loadable<Discardable>
    
    var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>, updatePasswordResult: Loadable<Discardable> = .notRequested) {
        self.appState = appState
        
        _updatePasswordResult = .init(initialValue: updatePasswordResult)
    }
    
    // MARK: - Methods
    func updatePassword() {
        let updatePasswordRequestDTO = UpdatePasswordRequestDTO(oldPassword: oldPassword, newPassword: newPassword, repeatedNewPassword: repeatedNewPassword)
        switch appState[\.data.selectedEntity] {
        case .user: updateUserPassword(with: updatePasswordRequestDTO)
        case .restaurant: updateRestaurantPassword(with: updatePasswordRequestDTO)
        }
    }
    
    func updateUserPassword(with updatePasswordRequestDTO: UpdatePasswordRequestDTO) {
        usersService.updateUserPassword(with: updatePasswordRequestDTO, updatePasswordResult: loadableSubject(\.updatePasswordResult))
    }
    
    func updateRestaurantPassword(with updatePasswordRequestDTO: UpdatePasswordRequestDTO) {
        restaurantsService.updateRestaurantPassword(with: updatePasswordRequestDTO, updatePasswordResult: loadableSubject(\.updatePasswordResult))
    }
    
    func updateProfile() {
        switch appState[\.data.selectedEntity] {
        case .user: appState[\.data.updateUserProfileView] = true
        case .restaurant: appState[\.data.updateRestaurantProfileView] = true
        }
        
    }
    
    func resetStates() {
        oldPassword = ""
        newPassword = ""
        repeatedNewPassword = ""
        updatePasswordResult.reset()
    }
}
