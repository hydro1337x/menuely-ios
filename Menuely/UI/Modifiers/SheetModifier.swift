//
//  SheetModifier.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 11.07.2021..
//

import SwiftUI

import SwiftUI

struct SheetViewModifier<Item: Identifiable, Destination: View>: ViewModifier {

    // MARK: Properties

    private let item: Binding<Item?>
    private let destination: (Item) -> Destination

    // MARK: Initialization

    init(item: Binding<Item?>,
         @ViewBuilder content: @escaping (Item) -> Destination) {

        self.item = item
        self.destination = content
    }

    // MARK: Methods

    func body(content: Content) -> some View {
        content.sheet(item: item, content: destination)
    }

}
