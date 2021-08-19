//
//  CategoriesListView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 29.07.2021..
//

import SwiftUI
import Resolver

struct CategoriesListDisplayInfo: Equatable, Hashable {
    let menuID: Int
    let menuName: String
    let interaction: OffersInteractionType
}

struct CategoriesListView: View {
    @StateObject private var viewModel: CategoriesListViewModel = Resolver.resolve()
    
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
            listContent
            operationContent
        }
        .navigationBarTitle(viewModel.title)
        .navigationBarItems(trailing: Button(action: {
            if viewModel.interactionType == .modifying {
                viewModel.routing.isCreateCategorySheetPresented = true
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
                }
                .frame(width: 55, height: 34)
                .background(Color(#colorLiteral(red: 0.3146468997, green: 0.7964186072, blue: 0.5054938793, alpha: 1)))
                .cornerRadius(17)
            }
        })
        .opacity(isTrailingButtonShown ? 1 : 0)
        )
        .sheet(isPresented: $viewModel.routing.isCreateCategorySheetPresented, onDismiss: {
            viewModel.routing.isCreateCategorySheetPresented = false
        }, content: {
            CreateCategoryView()
                .modifier(PopoversViewModifier())
                .modifier(RootViewAppearance())
        })
        .sheet(isPresented: viewModel.routing.updateCategory != nil ? .constant(true) : .constant(false), onDismiss: {
            viewModel.routing.updateCategory = nil
        }, content: {
            UpdateCategoryView()
                .modifier(PopoversViewModifier())
                .modifier(RootViewAppearance())
        })
    }
}

private extension CategoriesListView {
    @ViewBuilder
    private var listContent: some View {
        switch viewModel.categories {
        case .notRequested: listNotRequestedView
        case .isLoading(let last, _):  listLoadingView(last)
        case .loaded(let categories):  listLoadedView(categories, showLoading: false)
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

private extension CategoriesListView {
    var listNotRequestedView: some View {
        Text("").onAppear(perform: viewModel.getCategories)
    }
    
    func listLoadingView(_ previouslyLoaded: [Category]?) -> some View {
        if let categories = previouslyLoaded {
            return AnyView(listLoadedView(categories, showLoading: true))
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

private extension CategoriesListView {
    func listLoadedView(_ categories: [Category], showLoading: Bool) -> some View {
        if showLoading {
            viewModel.appState[\.routing.activityIndicator.isActive] = true
        } else {
            viewModel.appState[\.routing.activityIndicator.isActive] = false
        }
        return List {
            ForEach(categories) { category in
                NavigationLink(
                    destination: ProductsListView(),
                    tag: ProductsListDisplayInfo(categoryID: category.id, categoryName: category.name, imageURL: category.image.url, interaction: viewModel.interactionType),
                    selection: $viewModel.routing.products) {
                    CategoryCell(title: category.name, imageUrl: category.image.url, placeholderImage: .logo)
                    }
                    .onTapGesture {
                        viewModel.productsListView(for: category)
                    }
                    .contextMenu(menuItems: {
                        Button(action: {
                            viewModel.updateCategoryView(with: category)
                        }, label: {
                            Text("Edit")
                        })
                        
                        Button(action: {
                            viewModel.deletionAlertView(for: category)
                        }, label: {
                            Text("Delete")
                        })
                    })
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    func operationLoadedView() -> some View {
        viewModel.resetOperationsState()
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.getCategories()
        return EmptyView()
    }
}

extension CategoriesListView {
    struct Routing: Equatable {
        var isCreateCategorySheetPresented: Bool = false
        var updateCategory: Category?
        var products: ProductsListDisplayInfo?
        var cart: Bool?
    }
}

struct CategoriesListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesListView()
    }
}
