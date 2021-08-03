//
//  MenusListView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 26.07.2021..
//

import SwiftUI
import Resolver

struct MenusListView: View {
    @StateObject private var viewModel: MenusListViewModel = Resolver.resolve()
    
    @State private var isLongPressed: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                listContent
                operationContent
            }
            .navigationBarTitle("Menus")
            .navigationBarItems(trailing: Button(action: {
                viewModel.routing.isCreateMenuSheetPresented = true
            }, label: {
                Image(.plus)
                    .resizable()
                    .frame(width: 25, height: 25, alignment: .center)
            })
            .frame(width: 44, height: 44)
            )
            .sheet(isPresented: $viewModel.routing.isCreateMenuSheetPresented, onDismiss: {
                viewModel.routing.isCreateMenuSheetPresented = false
            }, content: {
                CreateMenuView()
                    .modifier(PopoversViewModifier())
                    .modifier(RootViewAppearance())
            })
            .sheet(isPresented: viewModel.routing.updateMenu != nil ? .constant(true) : .constant(false), onDismiss: {
                viewModel.routing.updateMenu = nil
            }, content: {
                UpdateMenuView()
                    .modifier(PopoversViewModifier())
                    .modifier(RootViewAppearance())
            })
        }
    }
}

private extension MenusListView {
    @ViewBuilder
    private var listContent: some View {
        switch viewModel.menus {
        case .notRequested: listNotRequestedView
        case .isLoading(let last, _):  listLoadingView(last)
        case .loaded(let menus):  listLoadedView(menus, showLoading: false)
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

private extension MenusListView {
    var listNotRequestedView: some View {
        Text("").onAppear(perform: viewModel.getMenus)
    }
    
    func listLoadingView(_ previouslyLoaded: [Menu]?) -> some View {
        if let menus = previouslyLoaded {
            return AnyView(listLoadedView(menus, showLoading: true))
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

private extension MenusListView {
    func listLoadedView(_ menus: [Menu], showLoading: Bool) -> some View {
        if showLoading {
            viewModel.appState[\.routing.activityIndicator.isActive] = true
        } else {
            viewModel.appState[\.routing.activityIndicator.isActive] = false
        }
        
        return List(menus) { menu in
            NavigationLink(
                destination: CategoriesListView(),
                tag: menu,
                selection: $viewModel.routing.categoriesForMenu) {
                    MenuCell(title: menu.name, description: menu.description, imageName: .menu)
                }
                .scaleEffect(isLongPressed ? 1.05 : 1)
                .onTapGesture {
                    viewModel.routing.categoriesForMenu = menu
                }
                .onLongPressGesture {
                    viewModel.actionView(for: menu) {
                        isLongPressed = false
                    }
                    isLongPressed = true
                }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    func operationLoadedView() -> some View {
        viewModel.resetOperationsState()
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.getMenus()
        return EmptyView()
    }
}

extension MenusListView {
    struct Routing: Equatable {
        var isCreateMenuSheetPresented: Bool = false
        var updateMenu: Menu?
        var categoriesForMenu: Menu?
    }
}

struct MenusListView_Previews: PreviewProvider {
    static var previews: some View {
        MenusListView()
    }
}
