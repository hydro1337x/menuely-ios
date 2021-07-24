//
//  UserProfileView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 22.07.2021..
//

import SwiftUI
import SDWebImageSwiftUI

struct UserProfileView: View {
    @InjectedObservedObject private var viewModel: UserProfileViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            content
        }
        .sheet(isPresented: $viewModel.routing.isProfileImagePickerSheetPresented, content: {
            ImagePicker(image: $viewModel.selectedProfileImage)
        })
        .sheet(isPresented: $viewModel.routing.isCoverImagePickerSheetPresented, content: {
            ImagePicker(image: $viewModel.selectedCoverImage)
        })
    }
}

private extension UserProfileView {
    @ViewBuilder
    private var content: some View {
        switch viewModel.userProfile {
        case .notRequested: notRequestedView
        case .isLoading(let last, _):  loadingView(last)
        case .loaded(let user):  loadedView(user, showLoading: false)
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Loading Content

private extension UserProfileView {
    var notRequestedView: some View {
        Text("").onAppear(perform: viewModel.getUserProfile)
    }
    
    func loadingView(_ previouslyLoaded: User?) -> some View {
        if let user = previouslyLoaded {
            return AnyView(loadedView(user, showLoading: true))
        } else {
            viewModel.appState[\.routing.activityIndicator.isActive] = true
            return AnyView(EmptyView())
        }
    }
    
    func failedView(_ error: Error) -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.appState[\.routing.error.message] = error.localizedDescription
        return EmptyView()
    }
}

// MARK: - Displaying Content

private extension UserProfileView {
    func loadedView(_ user: User, showLoading: Bool) -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        return VStack {
            ProfileHeaderView(coverImageURL: user.coverImage?.url ?? "",
                              profileImageURL: user.profileImage?.url ?? "",
                              title: user.name,
                              subtitle: user.email,
                              placeholderImageName: .person,
                              onProfileImageTap: {
                                viewModel.routing.isProfileImagePickerSheetPresented = true
                              },
                              onCoverImageTap: {
                                viewModel.routing.isCoverImagePickerSheetPresented = true
                              })
                .offset(y: -225)
            
            AccountInfoView(title: "Account info:", body1: "Created at: \(viewModel.timeIntervalToString(user.createdAt))", body2: "Updated at: \(viewModel.timeIntervalToString(user.updatedAt))", imageName: .person)
                .background(Color(#colorLiteral(red: 0.9646247029, green: 0.9647596478, blue: 0.9645821452, alpha: 1)))
                .cornerRadius(10)
                .shadow(radius: 3, y: 2)
                .offset(y: -100)
                .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
