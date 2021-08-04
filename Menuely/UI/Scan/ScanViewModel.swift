//
//  ScanViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 25.07.2021..
//

import Foundation
import Resolver

class ScanViewModel: ObservableObject {
    // MARK: - Properties
    @Published var routing: ScanView.Routing
    
    let appState: Store<AppState>
    private var cancelBag = CancelBag()
    // MARK: - Initialization
    init(appState: Store<AppState>) {
        self.appState = appState
        
        _routing = .init(initialValue: appState[\.routing.scan])
        
        cancelBag.collect {
            $routing
                .removeDuplicates()
                .sink { appState[\.routing.scan] = $0 }
            
            appState
                .map(\.routing.scan)
                .removeDuplicates()
                .assign(to: \.routing, on: self)
        }
    }
    
    
    // MARK: - Methods
    func errorView(with message: String?) {
        appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
    }
    
    func restaurantNoticeView(with urlString: String) {
        guard let url = URLComponents(string: urlString), let param = url.queryItems?.first(where: { $0.name == "menuId" })?.value, let id = Int(param) else { return }
        
        routing.restaurantNoticeForID = id
    }
}
