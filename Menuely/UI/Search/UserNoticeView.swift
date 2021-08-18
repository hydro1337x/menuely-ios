//
//  UserNoticeView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 04.08.2021..
//

import SwiftUI
import Resolver
import SDWebImageSwiftUI

struct UserNoticeView: View {
    @StateObject private var viewModel: ViewModel = Resolver.resolve()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(#colorLiteral(red: 0.948246181, green: 0.9496578574, blue: 0.9691624045, alpha: 1))
                    .edgesIgnoringSafeArea(.all)
                
                userContent
                    .edgesIgnoringSafeArea(.vertical)
                
                createInvitationContent
            }
        }
    }
}

private extension UserNoticeView {
    @ViewBuilder
    private var userContent: some View {
        switch viewModel.user {
        case .notRequested: notRequestedView
        case .isLoading(let last, _): loadingView(last)
        case .loaded(let user): userLoadedView(user, showLoading: false)
        case let .failed(error): failedView(error)
        }
    }
    
    @ViewBuilder
    private var createInvitationContent: some View {
        switch viewModel.createInvitationResult {
        case .notRequested: notRequestedView
        case .isLoading(_, _): loadingView(nil)
        case .loaded(_): createInvitationLoadedView()
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Loading Content

private extension UserNoticeView {
    var notRequestedView: some View {
        Text("").onAppear(perform: viewModel.getUser)
    }
    
    func loadingView(_ previouslyLoaded: User?) -> some View {
        if let user = previouslyLoaded {
            return AnyView(userLoadedView(user, showLoading: true))
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

private extension UserNoticeView {
    func userLoadedView(_ user: User, showLoading: Bool) -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        return ScrollView {
            StretchyHeader(imageURL: URL(string: user.coverImage?.url ?? ""))
            
            VStack(spacing: 0) {
                WebImage(url: URL(string: user.profileImage?.url ?? ""))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150, alignment: .center)
                    .background(Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1)))
                    .cornerRadius(10)
                    .shadow(radius: 3, y: 2)

                SectionView(title: "Info") {
                    DetailCell(title: "Email", text: user.email)
                }
                
                if let employer = user.employer {
                    SectionView(title: "Employer") {
                        DetailCell(title: "Name", text: employer.name)
                        
                        Divider()
                        
                        DetailCell(title: "Email", text: employer.email)
                        
                        Divider()
                        
                        Group {
                            DetailCell(title: "Country", text: employer.country)
                            
                            Divider()
                            
                            DetailCell(title: "City", text: employer.city)
                            
                            Divider()
                            
                            DetailCell(title: "Address", text: employer.address)
                            
                            Divider()
                        }
                        
                        DetailCell(title: "Postal code", text: employer.postalCode)
                    }
                }
                
                Button(action: {
                    viewModel.createInvitation()
                }, label: {
                    Text("Invite")
                })
                .frame(height: 48)
                .padding(.top, 10)
                .padding(.horizontal, 16)
                .buttonStyle(RoundedGradientButtonStyle())
            }
            .offset(y: -100 )
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(user.name)
    }
    
    func createInvitationLoadedView() -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.infoView()
        return EmptyView()
    }
}

struct UserNoticeView_Previews: PreviewProvider {
    static var previews: some View {
        UserNoticeView()
    }
}
