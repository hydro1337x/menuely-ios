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
        let updateEmailRequestDTO = UpdateEmailRequestDTO(email: email)
        switch appState[\.data.selectedEntity] {
        case .user: updateUserEmail(with: updateEmailRequestDTO)
        case .restaurant: updateRestaurantEmail(with: updateEmailRequestDTO)
        }
    }
    
    func updateUserEmail(with updateEmailRequestDTO: UpdateEmailRequestDTO) {
        usersService.updateUserEmail(with: updateEmailRequestDTO, updateEmailResult: loadableSubject(\.updateEmailResult))
    }
    
    func updateRestaurantEmail(with updateEmailRequestDTO: UpdateEmailRequestDTO) {
        restaurantsService.updateRestaurantEmail(with: updateEmailRequestDTO, updateEmailResult: loadableSubject(\.updateEmailResult))
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
}
