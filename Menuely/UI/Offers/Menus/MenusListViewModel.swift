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
        let queryRequestable = MenusQueryRequest(restaurantId: restaurantId)
        menusService.getMenus(with: queryRequestable, menus: loadableSubject(\.menus))
    }
    
    func deleteMenu(with id: Int) {
        menusService.deleteMenu(with: id, deleteMenuResult: loadableSubject(\.operationResult))
    }
    
    func resetOperationsState() {
        operationResult.reset()
    }
    
    // MARK: - Routing
    func categoriesListView(for menu: Menu) {
        routing.categories = CategoriesListDisplayInfo(menuID: menu.id, menuName: menu.name, interaction: .modifying)
    }
    
    func errorView(with message: String?) {
        appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
    }
    
    func updateMenuView(with menu: Menu) {
        appState[\.routing.menusList.updateMenu] = menu
    }
    
    func deletionAlertView(for menu: Menu) {
        let configuration = AlertViewConfiguration(title: "Delete menu", message: "Are you sure you want to delete \(menu.id)", primaryAction: {
            self.appState[\.routing.alert.configuration] = nil
            self.deleteMenu(with: menu.id)
        }, primaryButtonTitle: "Delete", secondaryAction: {
            self.appState[\.routing.alert.configuration] = nil
        }, secondaryButtonTitle: "Cancel")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.appState[\.routing.alert.configuration] = configuration
        }
    }
}
