//
//  ProductsListView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.07.2021..
//

import SwiftUI
import SDWebImageSwiftUI

let imageURL = "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjF8fHJlc3RhdXJhbnR8ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80"

struct MyValue: Identifiable {
    let id = UUID()
    let value: Int
}

struct ProductsListView: View {
    
    @State private var isTapped: Bool = false
    var  identifiables: [MyValue] = {
        var values: [MyValue] = []
        for i in 0..<10 {
            values.append(MyValue(value: i))
        }
        return values
    }()
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                ZStack {
                    if geometry.frame(in: .global).minY <= 0 {
                        WebImage(url: URL(string: imageURL))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .overlay(Rectangle()
                                        .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.3146468997, green: 0.7964186072, blue: 0.5054938793, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                                        .opacity(0.6))
                            .offset(y: geometry.frame(in: .global).minY/9)
                            .clipped()
                        
                    } else {
                        WebImage(url: URL(string: imageURL))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
                            .overlay(Rectangle()
                                        .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.3146468997, green: 0.7964186072, blue: 0.5054938793, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                                        .opacity(0.6))
                            .clipped()
                            .offset(y: -geometry.frame(in: .global).minY)
                    }
                }
            }
            .frame(height: 250)
            
            LazyVStack {
                ForEach(identifiables) { item in
                    ProductCell()
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitle("Products")
    }
}

struct MyView: View {
    let text: String
    @State private var isTapped: Bool = false
    
    var body: some View {
        Text(text)
            .frame(height: isTapped ? 200 : 100)
            .frame(maxWidth: .infinity)
            .background(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
            .padding(.all, 5)
            .onTapGesture {
                isTapped.toggle()
            }
    }
}

struct ProductsListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsListView()
    }
}
