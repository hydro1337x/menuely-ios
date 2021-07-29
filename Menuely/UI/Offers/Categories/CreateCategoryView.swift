//
//  CreateCategoryView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 29.07.2021..
//

import SwiftUI

struct CreateCategoryView: View {
    @InjectedObservedObject private var viewModel: CreateCategoryViewModel
    
    var body: some View {
        staticContent
        dynamicContent
    }
    
    private var staticContent: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
                    Image(uiImage: viewModel.image ?? UIImage(.category) ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150, alignment: .center)
                        .background(Image(.category))
                        .cornerRadius(10)
                        .shadow(radius: 3, y: 2)
                        .onTapGesture {
                            viewModel.routing.isImagePickerSheetPresented = true
                        }
                    
                    FloatingTextField(text: $viewModel.name, title: "Name")
                        .frame(height: 48)
                    
                    Button(action: {
                        viewModel.createCategory()
                    }, label: {
                        Text("Create")
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
            .navigationBarTitle("Create category")
            .sheet(isPresented: $viewModel.routing.isImagePickerSheetPresented, content: {
                ImagePicker(image: $viewModel.image)
            })
        }
    }
    
    @ViewBuilder
    private var dynamicContent: some View {
        switch viewModel.createCategoryResult {
        case .isLoading(_, _):  loadingView()
        case .loaded(_):  loadedView(showLoading: false)
        case let .failed(error): failedView(error)
        default: EmptyView()
        }
    }
}

private extension CreateCategoryView {
    
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

private extension CreateCategoryView {
    func loadedView(showLoading: Bool) -> some View {
        viewModel.resetStates()
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.updateCategoriesListView()
        viewModel.dismiss()
        return EmptyView()
    }
}

extension CreateCategoryView {
    struct Routing: Equatable {
        var isImagePickerSheetPresented: Bool = false
    }
}

struct CreateCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCategoryView()
    }
}
