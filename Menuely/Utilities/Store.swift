//
//  Store.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.06.2021..
//

import Combine
import SwiftUI

typealias Store<State> = CurrentValueSubject<State, Never>

extension Store {
    
    /// By implementing a subscript it makes it possible to use the [] operator on Store instances
    subscript<T>(keyPath: WritableKeyPath<Output, T>) -> T where T: Equatable {
        get { value[keyPath: keyPath] }
        set {
            // New instance is created, since Store is a value type (struct)
            var value = self.value
            if value[keyPath: keyPath] != newValue {
                value[keyPath: keyPath] = newValue
                self.value = value
            }
        }
    }
    
    
    
}
