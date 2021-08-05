//
//  UpdateProductView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 31.07.2021..
//

import SwiftUI
import SDWebImageSwiftUI
import Resolver

struct UpdateProductView: View {
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
                        if let image = viewModel.image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150, alignment: .center)
                                .foregroundColor(Color(#colorLiteral(red: 0.3146468997, green: 0.7964186072, blue: 0.5054938793, alpha: 1)))
                                .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                                .cornerRadius(10)
                                .shadow(radius: 3, y: 2)
                        } else {
                            WebImage(url: URL(string: viewModel.imageURL ?? ""))
                                .resizable()
                                .placeholder {
                                    Image(.logo).background(Color(#colorLiteral(red: 0.9646247029, green: 0.9647596478, blue: 0.9645821452, alpha: 1)))
                                }
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150, alignment: .center)
                                .background(Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1)))
                                .cornerRadius(10)
                                .shadow(radius: 3, y: 2)
                        }
                    })
                    
                    FloatingTextField(text: $viewModel.name, title: "Name")
                        .frame(height: 48)
                        .padding(.top, 10)
                    
                    FloatingTextField(text: $viewModel.description, title: "Description")
                        .frame(height: 48)
                        .padding(.top, 10)
                    
                    FloatingTextField(text: $viewModel.price, title: "Price")
                        .frame(height: 48)
                        .padding(.top, 10)
                    
                    Button(action: {
                        viewModel.updateProduct()
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
            .navigationBarTitle("Edit product")
            .sheet(isPresented: $viewModel.routing.isImagePickerSheetPresented, content: {
                ImagePicker(image: $viewModel.image)
            })
        }
    }
    
    @ViewBuilder
    private var dynamicContent: some View {
        switch viewModel.updateProductResult {
        case .isLoading(_, _):  loadingView()
        case .loaded(_):  loadedView(showLoading: false)
        case let .failed(error): failedView(error)
        default: EmptyView()
        }
    }
}

private extension UpdateProductView {
    
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

private extension UpdateProductView {
    func loadedView(showLoading: Bool) -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.updateProductsListView()
        viewModel.dismiss()
        return EmptyView()
    }
}

extension UpdateProductView {
    struct Routing: Equatable {
        var isImagePickerSheetPresented: Bool = false
    }
}

struct UpdateProductView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateProductView()
    }
}
