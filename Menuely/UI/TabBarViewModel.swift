//
//  TabBarViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 20.07.2021..
//

import Foundation

class TabBarViewModel: ObservableObject {
    @Published var tab: TabBarView.Routing
    
    private var cancelBag = CancelBag()
    
    init(appState: Store<AppState>) {
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
