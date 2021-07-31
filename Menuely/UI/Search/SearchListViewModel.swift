//
//  SearchListViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 31.07.2021..
//

import Foundation

extension SearchListView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        @Published var routing: SearchListView.Routing
        @Published var search: String = ""
        
        var appState: Store<AppState>
        private var cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>) {
            self.appState = appState
            
            _routing = .init(initialValue: appState[\.routing.searchList])
            
            cancelBag.collect {
                $routing
                    .removeDuplicates()
                    .sink { appState[\.routing.searchList] = $0 }
                
                appState
                    .map(\.routing.searchList)
                    .removeDuplicates()
                    .assign(to: \.routing, on: self)
                
                $search
                    .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
                    .removeDuplicates()
                    .sink { [weak self] in
                        self?.appState[\.data.searchList.search] = $0
                    }
            }
        }
        
        // MARK: - Methods
        
        // MARK: - Routing
    }
}
