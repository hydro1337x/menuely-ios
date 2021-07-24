//
//  OptionsView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.07.2021..
//

import SwiftUI

struct OptionsView: View {
    @InjectedObservedObject private var viewModel: OptionsViewModel
    
    var body: some View {
        ZStack {
            base
            dynamicContent
        }
    }
    
    var base: some View {
        NavigationView {
            VStack {
                Image(.logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding(.top, 20)
                
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
                .padding(.top, 10)
            }
            .navigationBarTitle("Options")
            .navigationBarTitleDisplayMode(.inline)
            
        }.accentColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
    }
    
    @ViewBuilder
    private var dynamicContent: some View {
        switch viewModel.logoutResult {
        case .isLoading(_, _):  loadingView()
        case .loaded(_):  loadedView(showLoading: false)
        case let .failed(error): failedView(error)
        default: EmptyView()
        }
    }
    
    @ViewBuilder
    func destinationView(for option: OptionType) -> some View {
        switch option {
        case .editProfile:
            switch viewModel.appState[\.data.selectedEntity] {
            case .user: EditUserProfileView()
            case .restaurant: EditRestaurantProfileView()
            }
        case .updatePassword: UpdatePasswordView()
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
        viewModel.appState[\.routing.error.message] = error.localizedDescription
        return EmptyView()
    }
}

// MARK: - Displaying Content

private extension OptionsView {
    func loadedView(showLoading: Bool) -> some View {
        viewModel.appState[\.routing.activityIndicator.isActive] = false
        viewModel.authSelectionViewRoute()
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
