//
//  AuthSelectionView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 09.07.2021..
//

import SwiftUI

struct AuthSelectionView: View {
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    
    var body: some View {
        VStack {
            Image(.logo)
                .frame(width: 100, height: 100, alignment: .center)
                .padding(.top, 10)
            Spacer()
            VStack {
                Text("Continue as")
                    .scaledFont(.title3)
                    .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                SelectionCardView(imageName: .person, text: "Private person")
                    .padding(.top, 10)
                SelectionCardView(imageName: .restaurant, text: "Restaurant")
                    .padding(.top, 10)
            }
            .offset(y: -100)
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

struct AuthSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AuthSelectionView()
    }
}
