//
//  OptionType.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.07.2021..
//

import Foundation

enum OptionType: String, Equatable {
    case updateProfile = "Edit profile"
    case updatePassword = "Change password"
    case updateEmail = "Change email"
    case quitEmployer = "Quit employer"
    case logout = "Logout"
    case deleteAccount = "Delete account"
}
