//
//  ProfileView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.07.2021..
//

import SwiftUI
import SDWebImageSwiftUI
import Resolver

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel = Resolver.resolve()
    
    var body: some View {
        
        NavigationView {
            Group {
                switch viewModel.appState[\.data.selectedEntity] {
                case .user:
                    UserProfileView()
                case .restaurant:
                    RestaurantProfileView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Profile")
            .navigationBarItems(trailing: Button(action: {
                viewModel.routing.isOptionsSheetPresented = true
            }, label: {
                Image(.hamburger)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
            }))
            .sheet(isPresented: $viewModel.routing.isOptionsSheetPresented, onDismiss: viewModel.resetNavigationStack, content: {
                OptionsView()
                    .modifier(PopoversViewModifier())
                    .modifier(RootViewAppearance())
            })
        }
    }
}

// MARK: - Routing
extension ProfileView {
    struct Routing: Equatable {
        var isOptionsSheetPresented: Bool = false
        var isProfileImagePickerSheetPresented: Bool = false
        var isCoverImagePickerSheetPresented: Bool = false
        var employerInvites: Bool?
        var userOrdersList: Bool?
        var restaurantOrdersList: Bool?
        var invitationsList: Bool?
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
