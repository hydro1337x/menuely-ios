//
//  RestaurantProfileView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 22.07.2021..
//

import SwiftUI
import SDWebImageSwiftUI

struct RestaurantProfileView: View {
    @InjectedObservedObject private var viewModel: RestaurantProfileViewModel
    
    @State private var animateErrorView: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            content
                .onAppear {
                    viewModel.resetStates()
                }
        }
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
        case .isLoading(let last, _):  loadingView(last)
        case .loaded(let restaurant):  loadedView(restaurant, showLoading: false)
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Loading Content

private extension RestaurantProfileView {
    var notRequestedView: some View {
        Text("")
            .onAppear(perform: viewModel.getRestaurantProfile)
    }
    
    @ViewBuilder
    func loadingView(_ previouslyLoaded: Restaurant?) -> some View {
        if let restaurant = previouslyLoaded {
            loadedView(restaurant, showLoading: true)
        } else {
            ActivityIndicatorView()
        }
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(isAnimating: $animateErrorView, message: error.localizedDescription) {
            viewModel.animateErrorView = false
        }
        .onReceive(viewModel.$animateErrorView, perform: { value in
            animateErrorView = value
        })
    }
}

// MARK: - Displaying Content

private extension RestaurantProfileView {
    func loadedView(_ restaurant: Restaurant, showLoading: Bool) -> some View {
        VStack {
            ProfileHeaderView(coverImageURL: restaurant.coverImage?.url ?? "",
                              profileImageURL: restaurant.profileImage?.url ?? "",
                              title: restaurant.name,
                              subtitle: restaurant.email,
                              placeholderImageName: .restaurant,
                              onProfileImageTap: {
                                viewModel.routing.isProfileImagePickerSheetPresented = true
                              },
                              onCoverImageTap: {
                                viewModel.routing.isCoverImagePickerSheetPresented = true
                              })
                .offset(y: -225)
            
            DescriptionView(title: "Description:", text: restaurant.description)
                .frame(maxHeight: 150)
                .background(Color(#colorLiteral(red: 0.9646247029, green: 0.9647596478, blue: 0.9645821452, alpha: 1)))
                .cornerRadius(10)
                .shadow(radius: 3, y: 2)
                .offset(y: -100)
                .padding(.horizontal, 30)
                
            
            AccountInfoView(title: "Account info:", body1: "Created at: \(viewModel.timeIntervalToString(restaurant.createdAt))", body2: "Updated at: \(viewModel.timeIntervalToString(restaurant.updatedAt))", imageName: .restaurant)
                .background(Color(#colorLiteral(red: 0.9646247029, green: 0.9647596478, blue: 0.9645821452, alpha: 1)))
                .cornerRadius(10)
                .shadow(radius: 3, y: 2)
                .offset(y: -100)
                .padding(.horizontal, 30)
                .padding(.top, 10)
            
            Spacer()
        }
    }
}

struct RestaurantProfileView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantProfileView()
    }
}
