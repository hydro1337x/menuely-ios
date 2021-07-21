//
//  ProfileHeaderView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 21.07.2021..
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileHeaderView: View {
    let coverImageUrl: String
    let profileImageUrl: String
    let name: String
    let email: String
    private let coverImageWidth = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            WebImage(url: URL(string: coverImageUrl))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: coverImageWidth, height: coverImageWidth, alignment: .top)
                .cornerRadius(25)
                .clipped()
                .overlay(RoundedRectangle(cornerRadius: 25)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1)), Color(#colorLiteral(red: 0.3146468997, green: 0.7964186072, blue: 0.5054938793, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                            .opacity(0.6))
            
            VStack {
                WebImage(url: URL(string: profileImageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150, alignment: .center)
                    .background(Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1)))
                    .cornerRadius(10)
                    .shadow(radius: 3, y: 2)
                
                Text(name)
                    .font(.title2).bold()
                    .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                
                Text(email)
                    .font(.body)
                    .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
            }
            .offset(y: 175)
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(coverImageUrl: "", profileImageUrl: "", name: "Name", email: "example@email.com")
    }
}
