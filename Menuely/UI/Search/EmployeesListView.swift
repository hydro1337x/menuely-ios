//
//  EmployeesListView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 03.08.2021..
//

import SwiftUI
import Resolver

struct EmployeesListView: View {
    @StateObject private var viewModel: ViewModel = Resolver.resolve()
    
    var body: some View {
        NavigationView {
            ZStack {
                listContent
                fireEmployeeContent
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationBarTitle("Employees")
        }
    }
}

private extension EmployeesListView {
    @ViewBuilder
    private var listContent: some View {
        switch viewModel.employees {
        case .notRequested: listNotRequestedView
        case .isLoading(let last, _):  listLoadingView(last)
        case .loaded(let employees):  listLoadedView(employees, showLoading: false)
        case let .failed(error): failedView(error)
        }
    }
    
    @ViewBuilder
    private var fireEmployeeContent: some View {
        switch viewModel.fireEmployeeResult {
        case .notRequested: EmptyView()
        case .isLoading(_, _):  listLoadingView(nil)
        case .loaded(_):  fireEmployeeLoadedView()
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Loading Content

private extension EmployeesListView {
    var listNotRequestedView: some View {
        Text("").onAppear(perform: viewModel.getEmployees)
    }
    
    func listLoadingView(_ previouslyLoaded: [User]?) -> some View {
        if let employees = previouslyLoaded {
            return AnyView(listLoadedView(employees, showLoading: true))
        } else {
            viewModel.appState[\.routing.activityIndicator.isActive] = true
            return AnyView(EmptyView())
        }
    }
    
    func operationLoadingView() -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = true
        return EmptyView()
    }
    
    func failedView(_ error: Error) -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.errorView(with: error.localizedDescription)
        return EmptyView()
    }
}

// MARK: - Displaying Content

private extension EmployeesListView {
    func listLoadedView(_ employees: [User], showLoading: Bool) -> some View {
        if showLoading {
            viewModel.appState[\.routing.activityIndicator.isActive] = true
        } else {
            viewModel.appState[\.routing.activityIndicator.isActive] = false
        }
        
        return List {
            ForEach(employees) { employee in
                SearchCell(title: employee.name, imageURL: URL(string: employee.profileImage?.url ?? ""))
                    .contextMenu(menuItems: {
                        Button(action: {
                            viewModel.fireEmployeeAlertView(with: employee)
                        }, label: {
                            Text("Fire")
                        })
                    })
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    func fireEmployeeLoadedView() -> some View {
        viewModel.fireEmployeeResult.reset()
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.getEmployees()
        return EmptyView()
    }
}

struct EmployeesListView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeesListView()
    }
}
