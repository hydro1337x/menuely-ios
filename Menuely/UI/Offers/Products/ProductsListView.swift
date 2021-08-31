//
//  ProductsListView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.07.2021..
//

import SwiftUI
import Resolver

struct ProductsListDisplayInfo: Equatable, Hashable {
    let categoryID: Int
    let categoryName: String
    let imageURL: String
    let interaction: OffersInteractionType
}

struct ProductsListView: View {
    @StateObject private var viewModel: ViewModel = Resolver.resolve()
    
    @State private var isLongPressed: Bool = false
    
    private var isTrailingButtonShown: Bool {
        if viewModel.interactionType == .modifying || ( viewModel.interactionType == .buying && (viewModel.cart?.cartItems.count) ?? 0 > 0) {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.948246181, green: 0.9496578574, blue: 0.9691624045, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            listContent
            operationContent
        }
        .navigationBarTitle(viewModel.title)
        .navigationBarItems(trailing: Button(action: {
            if viewModel.interactionType == .modifying {
                viewModel.routing.isCreateProductSheetPresented = true
            } else if viewModel.interactionType == .buying {
                viewModel.routing.cart = true
            }
        }, label: {
            if viewModel.interactionType == .modifying {
                Image(.plus)
                    .resizable()
                    .frame(width: 25, height: 25)
            } else if viewModel.interactionType == .buying {
                HStack {
                    NavigationLink(
                        destination: CartView(),
                        tag: true,
                        selection: $viewModel.routing.cart,
                        label: { EmptyView() })
                    Image(.cart)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                        .transition(.fade)
                        .animation(.easeInOut)
                }
                .frame(width: 55, height: 34)
                .background(Color(#colorLiteral(red: 0.3146468997, green: 0.7964186072, blue: 0.5054938793, alpha: 1)))
                .cornerRadius(17)
            }
        })
        .opacity(isTrailingButtonShown ? 1 : 0)
        )
        .edgesIgnoringSafeArea(.top)
        .sheet(isPresented: $viewModel.routing.isCreateProductSheetPresented, onDismiss: {
            viewModel.routing.isCreateProductSheetPresented = false
        }, content: {
            CreateProductView()
                .modifier(PopoversViewModifier())
                .modifier(ActivityViewModifier())
        })
        .sheet(isPresented: viewModel.routing.updateProduct != nil ? .constant(true) : .constant(false), onDismiss: {
            viewModel.routing.updateProduct = nil
        }, content: {
            EmptyView()
            UpdateProductView()
                .modifier(PopoversViewModifier())
                .modifier(ActivityViewModifier())
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
                    ProductCell(title: product.name,
                                description: product.description,
                                buttonTitle: viewModel.format(price: product.price, currency: product.currency),
                                extendedButtonTitle: viewModel.interactionType == .buying ? "Add to cart ( \(viewModel.format(price: product.price, currency: product.currency)) )" : nil,
                                imageURL: product.image.url,
                                action: viewModel.interactionType == .buying ? { viewModel.addCartItem(product) } : nil)
                        .contextMenu(menuItems: {
                            Button(action: {
                                viewModel.updateProductView(with: product)
                            }, label: {
                                Text("Edit")
                            })
                            
                            Button(action: {
                                viewModel.deletionAlertView(for: product)
                            }, label: {
                                Text("Delete")
                            })
                        })
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
        var cart: Bool?
    }
}

struct ProductsListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsListView()
    }
}
