//
//  UpdateEmailView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 25.07.2021..
//

import SwiftUI
import Resolver

struct UpdateEmailView: View {
    @StateObject private var viewModel: UpdateEmailViewModel = Resolver.resolve()
    
    var body: some View {
        ZStack {
            staticContent
            dynamicContent
        }
        .navigationBarTitle("Change email")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var staticContent: some View {
        ScrollView {
            VStack {
                FloatingTextField(text: $viewModel.email, title: "Email", validation: .email, isValid: $viewModel.isEmailValid)
                    .frame(height: 48)
                    .padding(.top, 15)
            }
            .padding(.horizontal, 16)
            .padding(.top, 25)
            
            Button("Save") {
                viewModel.updateEmail()
            }
            .font(.body)
            .frame(height: 48)
            .padding(.top, 20)
            .padding(.horizontal, 16)
            .buttonStyle(RoundedGradientButtonStyle())
            .disabled(!viewModel.isEmailValid)
        }
    }
    
    @ViewBuilder
    private var dynamicContent: some View {
        switch viewModel.updateEmailResult {
        case .isLoading(_, _):  loadingView()
        case .loaded(_):  loadedView(showLoading: false)
        case let .failed(error): failedView(error)
        default: EmptyView()
        }
    }
}

// MARK: - Loading content

private extension UpdateEmailView {
    
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

private extension UpdateEmailView {
    func loadedView(showLoading: Bool) -> some View {
        viewModel.resetStates()
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.updateProfile()
        viewModel.alertView()
        return EmptyView()
    }
}

struct UpdateEmailView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateEmailView()
    }
}
