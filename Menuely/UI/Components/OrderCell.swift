//
//  OrderCell.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 13.08.2021..
//

import SwiftUI
import SDWebImageSwiftUI

struct OrderCell: View {

    let title: String
    let subtitle: String
    let price: String
    let imageUrl: URL?
    let isActive: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            WebImage(url: imageUrl)
                .placeholder(content: {
                    Image(.logo).resizable().aspectRatio(contentMode: .fit)
                })
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .top, spacing: 0) {
                        Text(title)
                            .font(.callout).bold()
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .lineLimit(2)
                    }
                    
                    Text(subtitle)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .padding(.top, 5)
                    
                    Spacer()
                }
                .frame(maxHeight: .infinity)
                
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(isActive ? Color(#colorLiteral(red: 0.3146468997, green: 0.7964186072, blue: 0.5054938793, alpha: 1)) : Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1)))
                        .frame(width: 8, height: 8, alignment: .top)
                        .padding(.top, 5)
                    
                    Spacer()
                    
                    Button(action: {}, label: {
                        Text(price)
                            .font(.system(size: 14))
                    })
                    .frame(width: 100, height: 25)
                    .padding(.leading, 5)
                    .padding(.bottom, 15)
                    .buttonStyle(RoundedGradientButtonStyle())
                    .disabled(true)
                    
                    Spacer()
                }
            }
        }
        .frame(height: 100)
        .padding(.vertical, 5)
    }
}

struct OrderCell_Previews: PreviewProvider {
    static var previews: some View {
        OrderCell(title: "Restaurant rustica rustica", subtitle: " 22.10.2021. at 13:00 ", price: "100 HRK", imageUrl: URL(string: ""), isActive: true)
    }
}
