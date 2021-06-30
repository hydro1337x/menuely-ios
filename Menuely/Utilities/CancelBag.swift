//
//  CancelBag.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.06.2021..
//

import Combine

final class CancelBag {
    fileprivate(set) var cancellables = Set<AnyCancellable>()
    
    func cancel() {
        cancellables.removeAll()
    }
    
    func collect(@Builder _ cancellables: () -> [AnyCancellable]) {
        self.cancellables.formUnion(cancellables())
    }
    
    @resultBuilder
    struct Builder {
        static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
            return cancellables
        }
    }

}
