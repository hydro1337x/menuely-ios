//
//  SearchListView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 31.07.2021..
//

import SwiftUI
import Resolver

struct SearchListView: View {
    
    @StateObject private var viewModel: ViewModel = Resolver.resolve()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.search)
                
                switch viewModel.appState[\.data.selectedEntity] {
                case .user: RestaurantsSearchListView()
                case .restaurant: UsersSearchListView()
                }
                
                Spacer()
            }
            .navigationTitle("Search")
            .navigationBarItems(trailing: Button(action: {
                viewModel.routing.isShowEmployeesSheetPresented = true
            }, label: {
                Image(.employees)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 35)
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
            }))
            .sheet(isPresented: $viewModel.routing.isShowEmployeesSheetPresented, onDismiss: {
                viewModel.routing.isShowEmployeesSheetPresented = false
            }, content: {
                EmployeesListView()
                    .modifier(PopoversViewModifier())
                    .modifier(RootViewAppearance())
            })
        }
    }
}

extension SearchListView {
    struct Search: Equatable {
        var search: String?
    }
}

extension SearchListView {
    struct Routing: Equatable {
        var isShowEmployeesSheetPresented: Bool = false
    }
}

struct SearchListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchListView()
    }
}
