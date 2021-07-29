//
//  Image+Extension.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 10.07.2021..
//

import SwiftUI

extension Image {
    init(_ imageName: ImageName) {
        self.init(imageName.rawValue)
    }
}

extension UIImage {
    convenience init?(_ imageName: ImageName) {
        self.init(named: imageName.rawValue)
    }
}
