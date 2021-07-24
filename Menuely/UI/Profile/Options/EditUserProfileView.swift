//
//  EditUserProfileView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 23.07.2021..
//

import SwiftUI

struct EditUserProfileView: View {
    @InjectedObservedObject private var viewModel: EditUserProfileViewModel
    
    var body: some View {
        ZStack {
            staticContent
            dynamicContent
        }
        .onAppear {
            viewModel.loadFields()
        }
    }
    
    var staticContent: some View {
        ScrollView {
            Group {
                FloatingTextField(text: $viewModel.firstname, title: "Firstname")
                    .frame(height: 48)
                    .padding(.top, 15)
                
                FloatingTextField(text: $viewModel.lastname, title: "Lastname")
                    .frame(height: 48)
            }
            .padding(.horizontal, 30)
            
            Button("Save") {
                viewModel.updateUserProfile()
            }
            .font(.body)
            .frame(height: 48)
            .padding(.top, 20)
            .padding(.horizontal, 30)
            .buttonStyle(RoundedGradientButtonStyle())
        }
    }
    
    @ViewBuilder
    private var dynamicContent: some View {
        switch viewModel.updateProfileResult {
        case .isLoading(_, _):  loadingView()
        case .loaded(_):  loadedView(showLoading: false)
        case let .failed(error): failedView(error)
        default: EmptyView()
        }
    }
}

// MARK: - Loading content

private extension EditUserProfileView {
    
    func loadingView() -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = true
        return EmptyView()
    }
    
    func failedView(_ error: Error) -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.appState[\.routing.error.message] = error.localizedDescription
        return EmptyView()
    }
}

// MARK: - Displaying Content

private extension EditUserProfileView {
    func loadedView(showLoading: Bool) -> some View {
        viewModel.resetStates()
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.appState[\.data.shouldUpdateUserProfileView] = true
        viewModel.appState[\.routing.options.details] = nil
        return EmptyView()
    }
}

struct EditUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditUserProfileView()
    }
}
