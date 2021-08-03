//
//  EmployeesListViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 03.08.2021..
//

import Foundation
import Resolver

extension EmployeesListView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        @Injected private var restaurantsService: RestaurantsServicing
        
        @Published var employees: Loadable<[User]>
        
        var appState: Store<AppState>
        private var cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>, users: Loadable<[User]> = .notRequested) {
            self.appState = appState
            
            _employees = .init(initialValue: users)
                
        }
        
        // MARK: - Methods
        func getEmployees() {
            restaurantsService.getEmployees(employees: loadableSubject(\.employees))
        }
        
        // MARK: - Routing
        func errorView(with message: String?) {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
        }
    }
}
