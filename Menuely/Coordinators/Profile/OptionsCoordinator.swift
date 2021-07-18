//
//  OptionsCoordinator.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.07.2021..
//

import Foundation

class OptionsCoordinator: ObservableObject {
    // MARK: - Properties
    @Published var coordinating: Coordinating
    
    var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>) {
        _coordinating = .init(initialValue: appState[\.coordinating.options])
        
        cancelBag.collect {
            $coordinating
                .removeDuplicates()
                .sink { appState[\.coordinating.options] = $0 }
            
            appState
                .map(\.coordinating.options)
                .removeDuplicates()
                .assign(to: \.coordinating, on: self)
        }
    }
    
    // MARK: - Methods
}

extension OptionsCoordinator {
    enum Coordinating: Equatable {
        case initial
        case details(optionType: OptionType)
    }
}
