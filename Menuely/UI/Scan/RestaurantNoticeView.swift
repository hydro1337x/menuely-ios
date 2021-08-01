//
//  RestaurantNoticeView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.08.2021..
//

import SwiftUI
import SDWebImageSwiftUI

struct RestaurantNoticeView: View {
    var body: some View {
        ScrollView {
            StretchyHeader(imageURL: URL(string: "https://st.depositphotos.com/1026166/3160/v/600/depositphotos_31605339-stock-illustration-restaurant-food-quality-badge.jpg"))
            
            VStack(spacing: 0) {
                WebImage(url: URL(string: "https://st.depositphotos.com/1026166/3160/v/600/depositphotos_31605339-stock-illustration-restaurant-food-quality-badge.jpg"))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150, alignment: .center)
                    .background(Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1)))
                    .cornerRadius(10)
                    .shadow(radius: 3, y: 2)
                
                Form {
                    Section(header: Text("Description")) {
                        Text("Lorem ipsum dorem morem faflaLorem ipsum dorem morem faflaLorem ipsum dorem morem faflaLorem ipsum dorem morem faflaLorem ipsum dorem morem fafla")
                    }
                    
                    Section(header: Text("Info")) {
                        Text("Email")
                        Text("Phone")
                    }
                    
                    
                }
                .frame(height: 400)
                .disabled(true)
                Color(#colorLiteral(red: 0.948246181, green: 0.9496578574, blue: 0.9691624045, alpha: 1))
                    .frame(height: 300)
                Button(action: {}, label: {
                    Text("Open menu")
                })
                .frame(height: 48)
                .buttonStyle(RoundedGradientButtonStyle())
            }
            .offset(y: -100 )
        }
    }
}

struct RestaurantNoticeView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantNoticeView()
    }
}
