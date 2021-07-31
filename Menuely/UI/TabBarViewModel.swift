//
//  TabBarViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 20.07.2021..
//

import Foundation
import Resolver

class TabBarViewModel: ObservableObject {
    
    @Published var tab: TabBarView.Routing
    
    let appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    init(appState: Store<AppState>) {
        self.appState = appState
        
        _tab = .init(initialValue: appState[\.routing.tab])
        
        cancelBag.collect {
            $tab
                .removeDuplicates()
                .sink { appState[\.routing.tab] = $0 }
            
            appState
                .map(\.routing.tab)
                .removeDuplicates()
                .assign(to: \.tab, on: self)
        }
    }
    
}
