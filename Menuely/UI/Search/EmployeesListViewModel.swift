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
        @Published var fireEmployeeResult: Loadable<Discardable>
        
        var appState: Store<AppState>
        private var cancelBag = CancelBag()
        
        // MARK: - Initialization
        init(appState: Store<AppState>, users: Loadable<[User]> = .notRequested, fireEmployeeResult: Loadable<Discardable> = .notRequested) {
            self.appState = appState
            
            _employees = .init(initialValue: users)
            _fireEmployeeResult = .init(initialValue: fireEmployeeResult)
        }
        
        // MARK: - Methods
        func getEmployees() {
            restaurantsService.getEmployees(employees: loadableSubject(\.employees))
        }
        
        func fireEmployee(with id: Int) {
            let bodyRequest = FireEmployeeBodyRequest(employeeId: id)
            restaurantsService.fireEmployee(with: bodyRequest, fireEmployeeResult: loadableSubject(\.fireEmployeeResult))
        }
        
        // MARK: - Routing
        func errorView(with message: String?) {
            appState[\.routing.info.configuration] = InfoViewConfiguration(title: "Something went wrong", message: message)
        }
        
        func fireEmployeeAlertView(with employee: User) {
            let configuration = AlertViewConfiguration(title: "Fire employee", message: "Are you sure you want to fire \(employee.name)", primaryAction: {
                self.appState[\.routing.alert.configuration] = nil
                self.fireEmployee(with: employee.id)
            }, primaryButtonTitle: "Fire", secondaryAction: {
                self.appState[\.routing.alert.configuration] = nil
            }, secondaryButtonTitle: "Cancel")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.appState[\.routing.alert.configuration] = configuration
            }
        }
    }
}
