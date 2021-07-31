//
//  StretchyHeader.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.07.2021..
//

import SwiftUI
import SDWebImageSwiftUI

struct StretchyHeader: View {
    let imageURL: URL?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if geometry.frame(in: .global).minY <= 0 {
                    WebImage(url: imageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .overlay(Rectangle()
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.3146468997, green: 0.7964186072, blue: 0.5054938793, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                                    .opacity(0.6))
                        .offset(y: geometry.frame(in: .global).minY/9)
                        .clipped()
                    
                } else {
                    WebImage(url: imageURL)
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
    }
}

struct StretchyHeader_Previews: PreviewProvider {
    static var previews: some View {
        StretchyHeader(imageURL: URL(string: ""))
    }
}
