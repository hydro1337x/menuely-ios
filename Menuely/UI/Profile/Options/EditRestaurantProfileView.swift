//
//  EditRestaurantProfileView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 23.07.2021..
//

import SwiftUI

import SwiftUI

struct EditRestaurantProfileView: View {
    @InjectedObservedObject private var viewModel: EditRestaurantProfileViewModel
    
    var body: some View {
        ZStack {
            staticContent
            dynamicContent
        }
    }
    
    var staticContent: some View {
        ScrollView {
            Group {
                FloatingTextField(text: $viewModel.name, title: "Name")
                    .frame(height: 48)
                    .padding(.top, 15)
                
                FloatingTextField(text: $viewModel.description, title: "Description")
                    .frame(height: 48)
                
                FloatingTextField(text: $viewModel.country, title: "Country")
                    .frame(height: 48)
                
                FloatingTextField(text: $viewModel.city, title: "City")
                    .frame(height: 48)
                
                FloatingTextField(text: $viewModel.address, title: "Address")
                    .frame(height: 48)
                
                FloatingTextField(text: $viewModel.postalCode, title: "Postal code")
                    .frame(height: 48)
            }
            .padding(.horizontal, 30)
            
            Button("Save") {
                viewModel.updateRestaurantProfile()
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

private extension EditRestaurantProfileView {
    
    func loadingView() -> some View {
        return ActivityIndicatorView()
    }
    
    func failedView(_ error: Error) -> some View {
        viewModel.appState[\.routing.error.message] = error.localizedDescription
        return EmptyView()
    }
}

// MARK: - Displaying Content

private extension EditRestaurantProfileView {
    func loadedView(showLoading: Bool) -> some View {
        viewModel.resetStates()
        viewModel.appState[\.data.shouldUpdateRestaurantProfileView] = true
        viewModel.appState[\.routing.options.details] = nil
        return EmptyView()
    }
}

struct EditRestaurantProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditRestaurantProfileView()
    }
}
