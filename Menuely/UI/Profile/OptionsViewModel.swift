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
    
    var options: [OptionType] = [.editProfile, .changePassword, .deleteAccount, .logout]
    
    // MARK: - Initialization
    init() {}
    
    // MARK: - Methods
}
