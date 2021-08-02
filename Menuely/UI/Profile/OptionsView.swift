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
        VStack {
            List(viewModel.options, id: \.self) { option in
                if viewModel.navigatableOptions.contains(option) {
                    NavigationLink(
                        destination: destinationView(for: option),
                        tag: option,
                        selection: $viewModel.routing.details,
                        label: {
                            OptionItemView(option: option, imageName: .forwardArrow)
                                .frame(height: 48)
                        })
                        .buttonStyle(PlainButtonStyle())
                } else {
                    OptionItemView(option: option, imageName: .forwardArrow)
                        .frame(height: 48)
                        .onTapGesture {
                            switch option {
                            case .logout: viewModel.logoutAlertView()
                            case .deleteAccount: viewModel.deleteAccountAlertView()
                            default: break
                            }
                        }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .padding(.top, 10)
        }
    }
    
    @ViewBuilder
    private var dynamicContent: some View {
        switch viewModel.logoutResult {
        case .isLoading(_, _):  loadingView()
        case .loaded(_):  loadedView(showLoading: false)
        case let .failed(error): failedView(error)
        default: EmptyView()
        }
        
        switch viewModel.deleteAccountResult {
        case .isLoading(_, _):  loadingView()
        case .loaded(_):  loadedView(showLoading: false)
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
    func loadedView(showLoading: Bool) -> some View {
//        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.authSelectionView()
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
