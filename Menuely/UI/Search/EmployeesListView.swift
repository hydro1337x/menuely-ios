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
            listContent
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
        
        return ScrollView {
            LazyVStack {
                ForEach(employees) { employee in
                    SearchUsersCell(title: employee.name, description: employee.email, imageURL: URL(string: employee.profileImage?.url ?? ""))
                }
            }
        }
    }
}

struct EmployeesListView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeesListView()
    }
}
