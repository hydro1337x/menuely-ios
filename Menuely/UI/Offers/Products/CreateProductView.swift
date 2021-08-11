//
//  CreateProductView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 31.07.2021..
//

import SwiftUI
import Resolver

struct CreateProductView: View {
    @StateObject private var viewModel: ViewModel = Resolver.resolve()
    
    var body: some View {
        staticContent
        dynamicContent
    }
    
    private var staticContent: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Button(action: {
                        viewModel.routing.isImagePickerSheetPresented = true
                    }, label: {
                        Image(uiImage: viewModel.image ?? UIImage(.logo) ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150, alignment: .center)
                            .foregroundColor(Color(#colorLiteral(red: 0.3146468997, green: 0.7964186072, blue: 0.5054938793, alpha: 1)))
                            .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                            .cornerRadius(10)
                            .shadow(radius: 3, y: 2)
                    })
                    
                    FloatingTextField(text: $viewModel.name, title: "Name", type: .notEmpty, isValid: $viewModel.isNameValid)
                        .frame(height: 48)
                        .padding(.top, 10)
                    
                    FloatingTextEditor(text: $viewModel.description, title: "Description", isValid: $viewModel.isDescriptionValid)
                        .frame(height: 200)
                        .padding(.top, 15)
                    
                    FloatingTextField(text: $viewModel.price, title: "Price", type: .float, isValid: $viewModel.isPriceValid)
                        .frame(height: 48)
                        .padding(.top, 10)
                    
                    Button(action: {
                        viewModel.createProduct()
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
            .navigationBarTitle("Create product")
            .sheet(isPresented: $viewModel.routing.isImagePickerSheetPresented, content: {
                ImagePicker(image: $viewModel.image)
            })
        }
    }
    
    @ViewBuilder
    private var dynamicContent: some View {
        switch viewModel.createProductResult {
        case .isLoading(_, _):  loadingView()
        case .loaded(_):  loadedView(showLoading: false)
        case let .failed(error): failedView(error)
        default: EmptyView()
        }
    }
}

private extension CreateProductView {
    
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

private extension CreateProductView {
    func loadedView(showLoading: Bool) -> some View {
        viewModel.resetStates()
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.updateProductsListView()
        viewModel.dismiss()
        return EmptyView()
    }
}

extension CreateProductView {
    struct Routing: Equatable {
        var isImagePickerSheetPresented: Bool = false
    }
}

struct CreateProductView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProductView()
    }
}
