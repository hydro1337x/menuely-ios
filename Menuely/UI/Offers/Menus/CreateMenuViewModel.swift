//
//  CreateMenuViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 27.07.2021..
//

import Foundation
import Resolver

class CreateMenuViewModel: ObservableObject {
    // MARK: - Properties
    @Injected private var menusService: MenusServicing
    
    @Published var createMenuResult: Loadable<Discardable>
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var currency: String = ""
    @Published var numberOfTables: String = ""
    
    var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    // MARK: - Initialization
    init(appState: Store<AppState>, createMenuResult: Loadable<Discardable> = .notRequested) {
        self.appState = appState
        
        _createMenuResult = .init(initialValue: createMenuResult)
    }
    
    // MARK: - Methods
    func createMenu() {
        guard !name.isEmpty, !description.isEmpty, !currency.isEmpty, let numberOfTables = Int(numberOfTables), numberOfTables != 0 else { return }
        let createMenuRequestDTO = CreateMenuRequestDTO(name: name, description: description, currency: currency, numberOfTables: numberOfTables)
        menusService.createMenu(with: createMenuRequestDTO, createMenuResult: loadableSubject(\.createMenuResult))
    }
    
    func resetStates() {
        createMenuResult.reset()
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
        appState[\.routing.menusList.isCreateMenuSheetPresented] = false
    }
}
