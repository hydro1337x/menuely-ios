//
//  Image+Extension.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 10.07.2021..
//

import SwiftUI

extension Image {
    public enum ImageName: String {
        case logo
        case person
        case restaurant
        case scanTab = "scan.tab"
        case searchTab = "search.tab"
        case profileTab = "profile.tab"
        case hamburger = "hamburger"
        case forwardArrow = "forward.arrow"
        case menu = "menu"
        case plus = "plus"
    }
    
    public init(_ imageName: ImageName) {
        self.init(imageName.rawValue)
    }
}


