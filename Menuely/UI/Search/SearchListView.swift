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
