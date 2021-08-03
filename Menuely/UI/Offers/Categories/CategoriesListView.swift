//
//  CategoriesListView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 29.07.2021..
//

import SwiftUI
import Resolver

struct CategoriesListView: View {
    @StateObject private var viewModel: CategoriesListViewModel = Resolver.resolve()
    
    @State private var isLongPressed: Bool = false
    
    var body: some View {
        ZStack {
            listContent
            operationContent
        }
        .navigationBarTitle(viewModel.title)
        .navigationBarItems(trailing: Button(action: {
            viewModel.routing.isCreateCategorySheetPresented = true
        }, label: {
            Image(.plus)
                .resizable()
                .frame(width: 25, height: 25, alignment: .center)
        })
        .frame(width: 44, height: 44)
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
                    tag: category,
                    selection: $viewModel.routing.productsForCategory) {
                    CategoryCell(title: category.name, imageUrl: category.image.url, placeholderImage: .logo)
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                    .onTapGesture {
                        viewModel.routing.productsForCategory = category
                    }
                    .onLongPressGesture {
                        viewModel.actionView(for: category) {
                            isLongPressed = false
                        }
                        isLongPressed = true
                    }
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
        var productsForCategory: Category?
    }
}

struct CategoriesListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesListView()
    }
}
