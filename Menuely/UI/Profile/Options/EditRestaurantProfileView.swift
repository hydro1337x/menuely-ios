//
//  EditRestaurantProfileView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 23.07.2021..
//

import SwiftUI
import Resolver

struct EditRestaurantProfileView: View {
    @StateObject private var viewModel: EditRestaurantProfileViewModel = Resolver.resolve()
    
    var body: some View {
        ZStack {
            staticContent
            dynamicContent
        }
        .navigationBarTitle("Edit profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadFields()
        }
    }
    
    var staticContent: some View {
        ScrollView {
            VStack {
                FloatingTextField(text: $viewModel.name, title: "Name", validation: .notEmpty, isValid: $viewModel.isNameValid)
                    .frame(height: 48)
                    .padding(.top, 15)
                
                FloatingTextEditor(text: $viewModel.description, title: "Description", isValid: $viewModel.isDescriptionValid)
                    .frame(height: 200)
                    .padding(.top, 15)
                
                FloatingTextField(text: $viewModel.country, title: "Country", validation: .notEmpty, isValid: $viewModel.isCountryValid)
                    .frame(height: 48)
                
                FloatingTextField(text: $viewModel.city, title: "City", validation: .notEmpty, isValid: $viewModel.isCityValid)
                    .frame(height: 48)
                
                FloatingTextField(text: $viewModel.address, title: "Address", validation: .notEmpty, isValid: $viewModel.isAddressValid)
                    .frame(height: 48)
                
                FloatingTextField(text: $viewModel.postalCode, title: "Postal code", validation: .notEmpty, isValid: $viewModel.isPostalCodeValid)
                    .frame(height: 48)
            }
            .padding(.horizontal, 16)
            .padding(.top, 25)
            
            Button("Save") {
                viewModel.updateRestaurantProfile()
            }
            .font(.body)
            .frame(height: 48)
            .padding(.top, 20)
            .padding(.horizontal, 16)
            .buttonStyle(RoundedGradientButtonStyle())
            .disabled(!viewModel.isFormValid)
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

private extension EditRestaurantProfileView {
    func loadedView(showLoading: Bool) -> some View {
        viewModel.resetStates()
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.appState[\.data.updateRestaurantProfileView] = true
        viewModel.appState[\.routing.options.details] = nil
        return EmptyView()
    }
}

struct EditRestaurantProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditRestaurantProfileView()
    }
}
