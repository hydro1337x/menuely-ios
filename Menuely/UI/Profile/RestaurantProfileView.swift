//
//  RestaurantProfileView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 22.07.2021..
//

import SwiftUI
import SDWebImageSwiftUI
import Resolver

struct RestaurantProfileView: View {
    @StateObject private var viewModel: RestaurantProfileViewModel = Resolver.resolve()
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.948246181, green: 0.9496578574, blue: 0.9691624045, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            
            content
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $viewModel.routing.isProfileImagePickerSheetPresented, content: {
            ImagePicker(image: $viewModel.selectedProfileImage)
        })
        .sheet(isPresented: $viewModel.routing.isCoverImagePickerSheetPresented, content: {
            ImagePicker(image: $viewModel.selectedCoverImage)
        })
    }
}

private extension RestaurantProfileView {
    @ViewBuilder
    private var content: some View {
        switch viewModel.restaurantProfile {
        case .notRequested: notRequestedView
        case .isLoading(let last, _): loadingView(last)
        case .loaded(let restaurant): loadedView(restaurant, showLoading: false)
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Loading Content

private extension RestaurantProfileView {
    var notRequestedView: some View {
        Text("").onAppear(perform: viewModel.getRestaurantProfile)
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

private extension RestaurantProfileView {
    func loadedView(_ restaurant: Restaurant, showLoading: Bool) -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        return ScrollView {
            StretchyHeader(imageURL: URL(string: restaurant.coverImage?.url ?? ""))
                .onTapGesture {
                    viewModel.routing.isCoverImagePickerSheetPresented = true
                }
            
            VStack(spacing: 0) {
                WebImage(url: URL(string: restaurant.profileImage?.url ?? ""))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150, alignment: .center)
                    .background(Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1)))
                    .cornerRadius(10)
                    .shadow(radius: 3, y: 2)
                    .onTapGesture {
                        viewModel.routing.isProfileImagePickerSheetPresented = true
                    }
                
                Text(restaurant.name)
                    .font(.title3).bold()
                    .padding(.vertical, 20)
                
                SectionView(title: "Description") {
                    Text(restaurant.description)
                        .padding(.vertical, 10)
                }
                
                SectionView(title: "Info") {
                    DetailCell(title: "Email", text: restaurant.email)
                    
                    Divider()
                    
                    DetailCell(title: "Country", text: restaurant.country)
                    
                    Divider()
                    
                    DetailCell(title: "City", text: restaurant.city)
                    
                    Divider()
                    
                    DetailCell(title: "Address", text: restaurant.address)
                    
                    Divider()
                    
                    DetailCell(title: "Postal code", text: restaurant.postalCode)
                    
                    Group {
                        Divider()
                        
                        DetailCell(title: "Created", text: viewModel.timeIntervalToString(restaurant.createdAt))
                        
                        Divider()
                        
                        DetailCell(title: "Updated", text: viewModel.timeIntervalToString(restaurant.updatedAt))
                    }
                }
            }
            .offset(y: -100 )
        }
    }
}

struct RestaurantProfileView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantProfileView()
    }
}
