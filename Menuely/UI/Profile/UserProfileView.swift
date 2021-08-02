//
//  UserProfileView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 22.07.2021..
//

import SwiftUI
import SDWebImageSwiftUI
import Resolver

struct UserProfileView: View {
    @StateObject private var viewModel: UserProfileViewModel = Resolver.resolve()
    
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
        viewModel.errorView(with: error.localizedDescription)
        return EmptyView()
    }
}

// MARK: - Displaying Content

private extension UserProfileView {
    func loadedView(_ user: User, showLoading: Bool) -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        return ScrollView {
            StretchyHeader(imageURL: URL(string: user.coverImage?.url ?? ""))
                .onTapGesture {
                    viewModel.routing.isCoverImagePickerSheetPresented = true
                }
            
            VStack(spacing: 0) {
                WebImage(url: URL(string: user.profileImage?.url ?? ""))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150, alignment: .center)
                    .background(Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1)))
                    .cornerRadius(10)
                    .shadow(radius: 3, y: 2)
                    .onTapGesture {
                        viewModel.routing.isProfileImagePickerSheetPresented = true
                    }
                
                Text(user.name)
                    .font(.title3).bold()
                    .padding(.vertical, 20)
                
                SectionView(title: "Info") {
                    DetailCell(title: "Email", text: user.email)
                    
                    Divider()
                    
                    DetailCell(title: "Firstname", text: user.firstname)
                    
                    Divider()
                    
                    DetailCell(title: "Lastname", text: user.lastname)
                    
                    Group {
                        Divider()
                        
                        DetailCell(title: "Created", text: viewModel.timeIntervalToString(user.createdAt))
                        
                        Divider()
                        
                        DetailCell(title: "Updated", text: viewModel.timeIntervalToString(user.updatedAt))
                    }
                }
            }
            .offset(y: -100 )
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
