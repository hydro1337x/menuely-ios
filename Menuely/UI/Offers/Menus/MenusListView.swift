//
//  MenusListView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 26.07.2021..
//

import SwiftUI

struct MenusListView: View {
    @InjectedObservedObject private var viewModel: MenusListViewModel
    
    var body: some View {
        ZStack {
            content
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        print("Open create menu view")
                    }, label: {
                        Image(.plus)
                    })
                    .frame(width: 60, height: 60)
                    .buttonStyle(RoundedGradientButtonStyle(cornerRadius: 30))
                }
            }
        }
    }
}

private extension MenusListView {
    @ViewBuilder
    private var content: some View {
        switch viewModel.menus {
        case .notRequested: notRequestedView
        case .isLoading(let last, _):  loadingView(last)
        case .loaded(let menus):  loadedView(menus, showLoading: false)
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Loading Content

private extension MenusListView {
    var notRequestedView: some View {
        Text("").onAppear(perform: viewModel.getMenus)
    }
    
    func loadingView(_ previouslyLoaded: [Menu]?) -> some View {
        if let menus = previouslyLoaded {
            return AnyView(loadedView(menus, showLoading: true))
        } else {
            viewModel.appState[\.routing.activityIndicator.isActive] = true
            return AnyView(EmptyView())
        }
    }
    
    func failedView(_ error: Error) -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.errorView(with: error.localizedDescription)
        return EmptyView()
    }
}

// MARK: - Displaying Content

private extension MenusListView {
    func loadedView(_ menus: [Menu], showLoading: Bool) -> some View {
        if showLoading {
            viewModel.appState[\.routing.activityIndicator.isActive] = true
        } else {
            viewModel.appState[\.routing.activityIndicator.isActive] = false
        }
        return VStack {
            List(menus) { menu in
                NavigationLink(
                    destination: Text("New menu"),
                    tag: menu.id,
                    selection: .constant(17)) {
                        MenuCell(title: menu.name, description: menu.description, imageName: .menu)
                    }
            }
        }
    }
}

struct MenusListView_Previews: PreviewProvider {
    static var previews: some View {
        MenusListView()
    }
}
