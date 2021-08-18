//
//  OptionsView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.07.2021..
//

import SwiftUI
import Resolver

struct OptionsView: View {
    @StateObject private var viewModel: OptionsViewModel = Resolver.resolve()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(#colorLiteral(red: 0.948246181, green: 0.9496578574, blue: 0.9691624045, alpha: 1))
                    .edgesIgnoringSafeArea(.all)
                base
                dynamicContent
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationBarTitle("Options")
        }
    }
    
    var base: some View {
        List {
            Section(header: Text("Personal")) {
                ForEach(viewModel.personalOptions, id: \.self) { option in
                    switch option {
                    case .updateProfile, .updatePassword, .updateEmail:
                        NavigationLink(
                            destination: destinationView(for: option),
                            tag: option,
                            selection: $viewModel.routing.details,
                            label: {
                                OptionItemView(option: option, imageName: .forwardArrow)
                                    .frame(height: 48)
                            })
                            .buttonStyle(PlainButtonStyle())
                    case .userOrders, .deleteAccount, .logout, .incomingInvitations, .outgoingInvitations:
                        OptionItemView(option: option, imageName: .forwardArrow)
                            .frame(height: 48)
                            .onTapGesture {
                                switch option {
                                case .userOrders: viewModel.dismissAndShowUserOrdersListView()
                                case .incomingInvitations, .outgoingInvitations: viewModel.dismissAndShowInvitationsListView()
                                case .logout: viewModel.logoutAlertView()
                                case .deleteAccount: viewModel.deleteAccountAlertView()
                                default: break
                                }
                            }
                    default: EmptyView()
                    }
                }
            }
            
            
            if !viewModel.restaurantOptions.isEmpty {
                Section(header: Text("Restaurant")) {
                    ForEach(viewModel.restaurantOptions, id: \.self) { option in
                        switch option {
                        case .restaurantOrders, .quitEmployer:
                            OptionItemView(option: option, imageName: .forwardArrow)
                                .frame(height: 48)
                                .onTapGesture {
                                    switch option {
                                    case .quitEmployer: viewModel.quitEmployerAlertView()
                                    case .restaurantOrders: viewModel.dismissAndShowRestaurantOrdersListView()
                                    default: break
                                    }
                                }
                        default: EmptyView()
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    @ViewBuilder
    private var dynamicContent: some View {
        switch viewModel.logoutDeleteResult {
        case .isLoading(_, _):  loadingView()
        case .loaded(_):  logoutDeleteLoadedView(showLoading: false)
        case let .failed(error): failedView(error)
        default: EmptyView()
        }
        
        switch viewModel.quitEmployerResult {
        case .isLoading(_, _):  loadingView()
        case .loaded(_):  quitEmployerLoadedView()
        case let .failed(error): failedView(error)
        default: EmptyView()
        }
    }
    
    @ViewBuilder
    func destinationView(for option: OptionType) -> some View {
        switch option {
        case .updateProfile:
            switch viewModel.appState[\.data.selectedEntity] {
            case .user: EditUserProfileView()
            case .restaurant: EditRestaurantProfileView()
            }
        case .updatePassword: UpdatePasswordView()
        case .updateEmail: UpdateEmailView()
        default: EmptyView()
        }
    }
}

// MARK: - Loading Content

private extension OptionsView {
    
    func loadingView() -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = true
        return EmptyView()
    }
    
    func failedView(_ error: Error) -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.errorView(with: error.localizedDescription)
        return EmptyView()
    }
}

// MARK: - Displaying Content

private extension OptionsView {
    func logoutDeleteLoadedView(showLoading: Bool) -> some View {
        viewModel.authSelectionView()
        return EmptyView()
    }
    
    func quitEmployerLoadedView() -> some View {
        viewModel.dismissAndUpdateProfileView()
        return EmptyView()
    }
}

extension OptionsView {
    struct Routing: Equatable {
        var details: OptionType?
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
