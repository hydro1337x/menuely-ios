//
//  RestaurantNoticeView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.08.2021..
//

import SwiftUI
import Resolver
import SDWebImageSwiftUI

struct RestaurantNoticeView: View {
    @StateObject private var viewModel: ViewModel = Resolver.resolve()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(#colorLiteral(red: 0.948246181, green: 0.9496578574, blue: 0.9691624045, alpha: 1))
                    .edgesIgnoringSafeArea(.all)
                
                content
            }
        }
    }
}

private extension RestaurantNoticeView {
    @ViewBuilder
    private var content: some View {
        switch viewModel.restaurant {
        case .notRequested: notRequestedView
        case .isLoading(let last, _): loadingView(last)
        case .loaded(let restaurant): loadedView(restaurant, showLoading: false)
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Loading Content

private extension RestaurantNoticeView {
    var notRequestedView: some View {
        EmptyView()
    }
    
    func loadingView(_ previouslyLoaded: Restaurant?) -> some View {
        if let restaurant = previouslyLoaded {
            return AnyView(loadedView(restaurant, showLoading: true))
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

private extension RestaurantNoticeView {
    func loadedView(_ restaurant: Restaurant, showLoading: Bool) -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        return ScrollView {
            StretchyHeader(imageURL: URL(string: restaurant.coverImage?.url ?? ""))
            
            VStack(spacing: 0) {
                WebImage(url: URL(string: restaurant.profileImage?.url ?? ""))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150, alignment: .center)
                    .background(Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1)))
                    .cornerRadius(10)
                    .shadow(radius: 3, y: 2)
                
                SectionView(title: "Description") {
                    Text(restaurant.description)
                        .padding(.vertical, 10)
                }
                
                SectionView(title: "Info") {
                    DetailCell(title: "City", text: restaurant.city)
                    
                    Divider()
                    
                    DetailCell(title: "Address", text: restaurant.address)
                    
                    Divider()
                    
                    DetailCell(title: "Email", text: restaurant.email)
                }
                
                Button(action: {
                    viewModel.dismiss()
                }, label: {
                    Text("Open menu")
                })
                .frame(height: 48)
                .padding(.top, 10)
                .padding(.horizontal, 16)
                .buttonStyle(RoundedGradientButtonStyle())
            }
            .offset(y: -100 )
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(restaurant.name)
    }
}

struct RestaurantNoticeView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantNoticeView()
    }
}
