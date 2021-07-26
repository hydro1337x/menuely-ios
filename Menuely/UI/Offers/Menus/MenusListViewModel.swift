//
//  MenusListViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 26.07.2021..
//

import Foundation
import Resolver

class MenusListViewModel: ObservableObject {
    // MARK: - Properties
    @Injected private var menusService: MenusServicing
    
    @Published var menus: Loadable<[Menu]>
    @Published var modifyResult: Loadable<Discardable>
    
    var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>, menus: Loadable<[Menu]> = .notRequested, modifyResult: Loadable<Discardable> = .notRequested) {
        self.appState = appState
        
        _menus = .init(initialValue: menus)
        _modifyResult = .init(initialValue: modifyResult)
    }
    
    // MARK: - Methods
    func getMenus() {
        guard let restaurantId = appState[\.data.authenticatedRestaurant]?.restaurant.id else { return }
        let menusRequestDTO = MenusRequestDTO(restaurantId: restaurantId)
        menusService.getMenus(with: menusRequestDTO, menus: loadableSubject(\.menus))
    }
    
    // MARK: - Routing
    func errorView(with message: String?) {
        appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
    }
}
