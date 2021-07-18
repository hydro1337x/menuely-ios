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
            if isLogoutAlertShown {
                logoutAlertView
            }
            if isDeleteAccountAlertShown {
                deleteAccountAlertView
            }
        }
    }
    
    var base: some View {
        VStack {
            Image(.logo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            
            List(viewModel.options, id: \.self) { option in
                OptionItemView(option: option, imageName: .forwardArrow)
                    .frame(height: 48)
                    .onTapGesture {
                        handleOptionItemTap(option: option)
                    }
            }
            .padding(.top, 30)
        }
    }
    
    var logoutAlertView: some View {
        AlertView(title: "Logout?", message: "Are you sure you want to logout?", primaryButton: Button(action: {
            // Logout
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
    
    func handleOptionItemTap(option: OptionType) {
        switch option {
        case .editProfile, .changePassword, .switchToEmployee, .swithToUser: viewModel.appState[\.coordinating.options] = .details(optionType: option)
        case .logout: isLogoutAlertShown = true
        case .deleteAccount: isDeleteAccountAlertShown = true
        }
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
