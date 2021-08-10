//
//  CreateMenuView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 26.07.2021..
//

import SwiftUI
import Resolver

struct CreateMenuView: View {
    @StateObject private var viewModel: CreateMenuViewModel = Resolver.resolve()
    
    var body: some View {
        staticContent
        dynamicContent
    }
    
    private var staticContent: some View {
        NavigationView {
            ScrollView {
                VStack {
                    FloatingTextField(text: $viewModel.name, title: "Name", type: .lenght(1), isValid: $viewModel.isNameValid)
                        .frame(height: 48)
                    
                    FloatingTextField(text: $viewModel.currency, title: "Currency", type: .lenght(1), isValid: $viewModel.isCurrencyValid)
                        .frame(height: 48)
                    
                    FloatingTextField(text: $viewModel.numberOfTables, title: "Number of tables", type: .lenght(1), isValid: $viewModel.isNumberOfTablesValid)
                        .frame(height: 48)
                    
                    FloatingTextEditor(text: $viewModel.description, title: "Description")
                        .frame(height: 200)
                    
                    Button(action: {
                        viewModel.createMenu()
                    }, label: {
                        Text("Create")
                    })
                    .frame(height: 48)
                    .padding(.top, 20)
                    .buttonStyle(RoundedGradientButtonStyle())
                    .disabled(!viewModel.isFormValid)
                }
                .padding(.top, 25)
                .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Create menu")
        }
    }
    
    @ViewBuilder
    private var dynamicContent: some View {
        switch viewModel.createMenuResult {
        case .isLoading(_, _):  loadingView()
        case .loaded(_):  loadedView(showLoading: false)
        case let .failed(error): failedView(error)
        default: EmptyView()
        }
    }
}

private extension CreateMenuView {
    
    func loadingView() -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = true
        return EmptyView()
    }
    
    func failedView(_ error: Error) -> some View {
        viewModel.resetStates()
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.errorView(with: error.localizedDescription)
        return EmptyView()
    }
}

// MARK: - Displaying Content

private extension CreateMenuView {
    func loadedView(showLoading: Bool) -> some View {
        viewModel.resetStates()
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.updateMenusListView()
        viewModel.dismiss()
        return EmptyView()
    }
}

struct CreateMenuView_Previews: PreviewProvider {
    static var previews: some View {
        CreateMenuView()
    }
}
