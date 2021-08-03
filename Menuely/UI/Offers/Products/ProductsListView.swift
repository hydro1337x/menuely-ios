//
//  ProductsListView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.07.2021..
//

import SwiftUI
import Resolver

struct ProductsListView: View {
    @StateObject private var viewModel: ViewModel = Resolver.resolve()
    
    @State private var isLongPressed: Bool = false
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.948246181, green: 0.9496578574, blue: 0.9691624045, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            listContent
            operationContent
        }
        .navigationBarTitle(viewModel.title)
        .navigationBarItems(trailing: Button(action: {
            viewModel.routing.isCreateProductSheetPresented = true
        }, label: {
            Image(.plus)
                .resizable()
                .frame(width: 25, height: 25, alignment: .center)
        })
        .frame(width: 44, height: 44)
        )
        .edgesIgnoringSafeArea(.top)
        .sheet(isPresented: $viewModel.routing.isCreateProductSheetPresented, onDismiss: {
            viewModel.routing.isCreateProductSheetPresented = false
        }, content: {
            CreateProductView()
                .modifier(PopoversViewModifier())
                .modifier(RootViewAppearance())
        })
        .sheet(isPresented: viewModel.routing.updateProduct != nil ? .constant(true) : .constant(false), onDismiss: {
            viewModel.routing.updateProduct = nil
        }, content: {
            EmptyView()
            UpdateProductView()
                .modifier(PopoversViewModifier())
                .modifier(RootViewAppearance())
        })
    }
}

private extension ProductsListView {
    @ViewBuilder
    private var listContent: some View {
        switch viewModel.products {
        case .notRequested: listNotRequestedView
        case .isLoading(let last, _):  listLoadingView(last)
        case .loaded(let products):  listLoadedView(products, showLoading: false)
        case let .failed(error): failedView(error)
        }
    }
    
    @ViewBuilder
    private var operationContent: some View {
        switch viewModel.operationResult {
        case .notRequested: EmptyView()
        case .isLoading(_, _):  operationLoadingView()
        case .loaded(_):  operationLoadedView()
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Loading Content

private extension ProductsListView {
    var listNotRequestedView: some View {
        Text("").onAppear(perform: viewModel.getProducts)
    }
    
    func listLoadingView(_ previouslyLoaded: [Product]?) -> some View {
        if let products = previouslyLoaded {
            return AnyView(listLoadedView(products, showLoading: true))
        } else {
            viewModel.appState[\.routing.activityIndicator.isActive] = true
            return AnyView(EmptyView())
        }
    }
    
    func operationLoadingView() -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = true
        return EmptyView()
    }
    
    func failedView(_ error: Error) -> some View {
        viewModel.resetOperationsState()
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.errorView(with: error.localizedDescription)
        return EmptyView()
    }
}

// MARK: - Displaying Content

private extension ProductsListView {
    func listLoadedView(_ products: [Product], showLoading: Bool) -> some View {
        if showLoading {
            viewModel.appState[\.routing.activityIndicator.isActive] = true
        } else {
            viewModel.appState[\.routing.activityIndicator.isActive] = false
        }
        
        return ScrollView {
            StretchyHeader(imageURL: viewModel.categoryImageURL)
            
            LazyVStack {
                ForEach(products) { product in
                    ProductCell(title: product.name, description: product.description, buttonTitle: product.price.description, imageURL: product.image.url)
                        .onLongPressGesture {
                            viewModel.actionView(for: product) {
                                isLongPressed = false
                            }
                            isLongPressed = true
                        }
                }
            }
        }
    }
    
    func operationLoadedView() -> some View {
        viewModel.resetOperationsState()
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.getProducts()
        return EmptyView()
    }
}

extension ProductsListView {
    struct Routing: Equatable {
        var isCreateProductSheetPresented: Bool = false
        var updateProduct: Product?
    }
}

struct ProductsListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsListView()
    }
}
