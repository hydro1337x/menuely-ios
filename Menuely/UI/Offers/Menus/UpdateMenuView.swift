//
//  UpdateMenuView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 27.07.2021..
//

import SwiftUI
import Resolver

struct UpdateMenuView: View {
    @StateObject private var viewModel: UpdateMenuViewModel = Resolver.resolve()
    
    var body: some View {
        staticContent
        dynamicContent
    }
    
    private var staticContent: some View {
        NavigationView {
            ScrollView {
                VStack {
                    FloatingTextField(text: $viewModel.name, title: "Name")
                        .frame(height: 48)
                    
                    FloatingTextField(text: $viewModel.currency, title: "Currency")
                        .frame(height: 48)
                    
                    FloatingTextEditor(text: $viewModel.description, title: "Description")
                        .frame(height: 200)
                    
                    Button(action: {
                        viewModel.updateMenu()
                    }, label: {
                        Text("Save")
                    })
                    .frame(height: 48)
                    .padding(.top, 20)
                    .buttonStyle(RoundedGradientButtonStyle())
                }
                .padding(.top, 25)
                .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Edit menu")
        }
    }
    
    @ViewBuilder
    private var dynamicContent: some View {
        switch viewModel.updateMenuResult {
        case .isLoading(_, _):  loadingView()
        case .loaded(_):  loadedView(showLoading: false)
        case let .failed(error): failedView(error)
        default: EmptyView()
        }
    }
}

private extension UpdateMenuView {
    
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

private extension UpdateMenuView {
    func loadedView(showLoading: Bool) -> some View {
        viewModel.resetStates()
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.updateMenusListView()
        viewModel.dismiss()
        return EmptyView()
    }
}

struct UpdateMenuView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateMenuView()
    }
}
