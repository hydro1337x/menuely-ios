//
//  ScanViewModel.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 25.07.2021..
//

import Foundation
import Resolver

class ScanViewModel: ObservableObject {
    // MARK: - Properties
    var code: String? {
        didSet {
            print("Code: ", code)
        }
    }
    
    // MARK: - Methods
}
