//
//  OptionsView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.07.2021..
//

import SwiftUI

struct OptionsView: View {
    @InjectedObservedObject private var viewModel: OptionsViewModel
    
    @State private var isLogoutAlertShown: Bool = false
    @State private var isDeleteAccountAlertShown: Bool = false
    
    var body: some View {
        ZStack {
            base
            dynamicContent
            if isLogoutAlertShown {
                logoutAlertView
            }
            if isDeleteAccountAlertShown {
                deleteAccountAlertView
            }
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
                                case .logout: isLogoutAlertShown = true
                                case .deleteAccount: isDeleteAccountAlertShown = true
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
    
    var logoutAlertView: some View {
        AlertView(title: "Logout?", message: "Are you sure you want to logout?", primaryButton: Button(action: {
            viewModel.logout()
            isLogoutAlertShown = false
        }, label: {
            Text("Logout")
        }), secondaryButton: Button(action: {
            isLogoutAlertShown = false
        }, label: {
            Text("Cancel")
        }))
    }
    
    var deleteAccountAlertView: some View {
        AlertView(title: "Delete account?", message: "Are you sure you want to delete your account?", primaryButton: Button(action: {
            // Delete account
        }, label: {
            Text("Delete")
        }), secondaryButton: Button(action: {
            isDeleteAccountAlertShown = false
        }, label: {
            Text("Cancel")
        }))
    }
    
    @ViewBuilder
    func destinationView(for option: OptionType) -> some View {
        switch option {
        case .editProfile:
            switch viewModel.appState[\.data.selectedEntity] {
            case .user: EditUserProfileView()
            case .restaurant: EditRestaurantProfileView()
            }
        default: EmptyView()
        }
    }
}

// MARK: - Loading Content

private extension OptionsView {
    
    func loadingView() -> some View {
        return ActivityIndicatorView().padding()
    }
    
    func failedView(_ error: Error) -> some View {
        viewModel.appState[\.routing.error.message] = error.localizedDescription
        return EmptyView()
    }
}

// MARK: - Displaying Content

private extension OptionsView {
    func loadedView(showLoading: Bool) -> some View {
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
