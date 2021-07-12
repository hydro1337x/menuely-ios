//
//  AuthSelectionView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 09.07.2021..
//

import SwiftUI

struct AuthSelectionView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                Image(.logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
                
                Spacer()
                
                VStack {
                    Text("Continue as")
                        .scaledFont(.title3)
                        .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                    
                    NavigationLink(
                        destination: UserRegistrationView(),
                        label: {
                            SelectionCardView(imageName: .person, text: "Private person")
                        })
                        .buttonStyle(SelectionCardButtonStyle())
                    
                    NavigationLink(
                        destination: RestaurantRegistrationView(),
                        label: {
                            SelectionCardView(imageName: .restaurant, text: "Restaurant")
                        })
                        .buttonStyle(SelectionCardButtonStyle())
                }
                .offset(y: -100)
                
                Spacer()
            }
            .padding(.horizontal, 30)
        }
    }
}

struct AuthSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AuthSelectionView()
    }
}
