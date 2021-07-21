//
//  ProfileView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.07.2021..
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @InjectedObservedObject private var viewModel: ProfileViewModel
    
    var body: some View {
        
        ScrollView {
            ZStack {
               staticContent
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Profile")
        .navigationBarItems(trailing: Button(action: {
            viewModel.routing.isOptionsSheetPresented = true
        }, label: {
            Image(.menu)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
        }))
        .sheet(isPresented: $viewModel.routing.isOptionsSheetPresented, content: {
            OptionsView()
                .onDisappear {
                    viewModel.resetNavigationStack()
                }
        })
    }
}

// MARK: - Static Content
extension ProfileView {
    var staticContent: some View {
        VStack {
            ProfileHeaderView(coverImageUrl: "https://i.natgeofe.com/n/2589f03e-85e8-4cdc-85fd-285c8a489bcb/01-edge-of-space-sts080-759-038_orig_16x9.jpg?w=1200", profileImageUrl: "https://i.natgeofe.com/n/2589f03e-85e8-4cdc-85fd-285c8a489bcb/01-edge-of-space-sts080-759-038_orig_16x9.jpg?w=1200", name: viewModel.name, email: "email@emil.com")
                .offset(y: -225)
            
            AccountInfoView(title: "Account info:", body1: "Created: 15.02.2020", body2: "Created: 15.02.2020", imageName: .person)
                .background(Color(#colorLiteral(red: 0.9646247029, green: 0.9647596478, blue: 0.9645821452, alpha: 1)))
                .cornerRadius(10)
                .shadow(radius: 3, y: 2)
                .offset(y: -100)
                .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

// MARK: - Dynamic Content

// MARK: - Routing
extension ProfileView {
    struct Routing: Equatable {
        var isOptionsSheetPresented: Bool = false
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
