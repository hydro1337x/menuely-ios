//
//  CreateMenuView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 26.07.2021..
//

import SwiftUI

struct CreateMenuView: View {
    @InjectedObservedObject private var viewModel: CreateMenuViewModel
    
    var body: some View {
        staticContent
        dynamicContent
    }
    
    private var staticContent: some View {
        NavigationView {
            VStack {
                FloatingTextField(text: $viewModel.name, title: "Name")
                    .frame(height: 48)
                
                FloatingTextField(text: $viewModel.currency, title: "Currency")
                    .frame(height: 48)
                
                FloatingTextField(text: $viewModel.numberOfTables, title: "Number of tables")
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
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
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
