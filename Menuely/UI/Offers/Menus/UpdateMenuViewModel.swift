//
//  UpdateMenuViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 27.07.2021..
//

import Foundation
import Resolver

class UpdateMenuViewModel: ObservableObject {
    // MARK: - Properties
    @Injected private var menusService: MenusServicing
    
    @Published var updateMenuResult: Loadable<Discardable>
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var currency: String = ""
    
    var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>, updateMenuResult: Loadable<Discardable> = .notRequested) {
        self.appState = appState
        
        _updateMenuResult = .init(initialValue: updateMenuResult)
        
        name =  appState[\.routing.menusList.menuForUpdate]?.name ?? ""
        description =  appState[\.routing.menusList.menuForUpdate]?.description ?? ""
        currency =  appState[\.routing.menusList.menuForUpdate]?.currency ?? ""
    }
    
    // MARK: - Methods
    func updateMenu() {
        guard let menu = appState[\.routing.menusList.menuForUpdate] else { return }
        let updateMenuRequestDTO = UpdateMenuRequestDTO(name: name.isEmpty ? nil : name, description: description.isEmpty ? nil : description, currency: currency.isEmpty ? nil : currency)
        menusService.updateMenu(with: menu.id, and: updateMenuRequestDTO, updateMenuResult: loadableSubject(\.updateMenuResult))
    }
    
    func resetStates() {
        updateMenuResult.reset()
    }
    
    func updateMenusListView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.appState[\.data.updateMenusListView] = true
        }
    }
    
    // MARK: - Routing
    func errorView(with message: String?) {
        appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
    }
    
    func dismiss() {
        appState[\.routing.menusList.menuForUpdate] = nil
    }
}
