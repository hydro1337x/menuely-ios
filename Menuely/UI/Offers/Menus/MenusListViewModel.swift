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
    
    @Published var routing: MenusListView.Routing
    @Published var menus: Loadable<[Menu]>
    @Published var operationResult: Loadable<Discardable>
    
    var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>, menus: Loadable<[Menu]> = .notRequested, operationResult: Loadable<Discardable> = .notRequested) {
        self.appState = appState
        
        _routing = .init(initialValue: appState[\.routing.menusList])
        _menus = .init(initialValue: menus)
        _operationResult = .init(initialValue: operationResult)
        
        cancelBag.collect {
            appState
                .map(\.data.updateMenusListView)
                .removeDuplicates()
                .sink { shouldUpdateMenusListView in
                    if shouldUpdateMenusListView {
                        appState[\.data.updateMenusListView] = false
                        self.getMenus()
                    }
                }
            
            $routing
                .removeDuplicates()
                .sink { appState[\.routing.menusList] = $0 }
            
            appState
                .map(\.routing.menusList)
                .removeDuplicates()
                .assign(to: \.routing, on: self)
                
        }
    }
    
    // MARK: - Methods
    func getMenus() {
        guard let restaurantId = appState[\.data.authenticatedRestaurant]?.restaurant.id else { return }
        let menusRequestDTO = MenusQueryRequest(restaurantId: restaurantId)
        menusService.getMenus(with: menusRequestDTO, menus: loadableSubject(\.menus))
    }
    
    func deleteMenu(with id: Int) {
        menusService.deleteMenu(with: id, deleteMenuResult: loadableSubject(\.operationResult))
    }
    
    func resetOperationsState() {
        operationResult.reset()
    }
    
    // MARK: - Routing
    func errorView(with message: String?) {
        appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
    }
    
    func deletionAlertView(for menu: Menu) {
        let configuration = AlertViewConfiguration(title: "Delete menu", message: "Are you sure you want to delete \(menu.id)", primaryAction: {
            self.appState[\.routing.alert.configuration] = nil
            self.deleteMenu(with: menu.id)
        }, primaryButtonTitle: "Delete", secondaryAction: {
            self.appState[\.routing.alert.configuration] = nil
        }, secondaryButtonTitle: "Cancel")
        appState[\.routing.alert.configuration] = configuration
    }
    
    func actionView(for menu: Menu, with additionalAction: @escaping () -> Void) {
        let delete = Action(name: "Delete") {
            self.appState[\.routing.action.configuration] = nil
            self.deletionAlertView(for: menu)
        }
        
        let update = Action(name: "Edit") {
            self.appState[\.routing.action.configuration] = nil
            self.appState[\.routing.menusList.menuForUpdate] = menu
        }
        
        let configuration = ActionViewConfiguration(title: "\(menu.name) actions", actions: [update, delete]) {
            additionalAction()
            self.appState[\.routing.action.configuration] = nil
        }
        
        appState[\.routing.action.configuration] = configuration
    }
}
