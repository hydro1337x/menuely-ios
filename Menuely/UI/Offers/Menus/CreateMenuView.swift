//
//  CreateMenuView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 26.07.2021..
//

import SwiftUI

struct CreateMenuView: View {
    var body: some View {
        Text("Create menu")
            .font(.title3).bold()
        
//        VStack {
//            FloatingTextField(text: $viewModel.password, title: "Password")
//                .frame(height: 48)
//            
//            FloatingTextField(text: $viewModel.name, title: "Name")
//                .frame(height: 48)
//            
//            FloatingTextEditor(text: $viewModel.description, title: "Description")
//                .frame(height: 200)
//            
//            FloatingTextField(text: $viewModel.country, title: "Country")
//                .frame(height: 48)
//        }
    }
}

struct CreateMenuView_Previews: PreviewProvider {
    static var previews: some View {
        CreateMenuView()
    }
}
