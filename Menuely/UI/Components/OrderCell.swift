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
    let isActive: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            Rectangle()
                .frame(width: 25, height: 50)
                .foregroundColor(isActive ? Color(#colorLiteral(red: 0.9781840444, green: 0.2009097934, blue: 0.2820017338, alpha: 1)) : Color(#colorLiteral(red: 0.3146468997, green: 0.7964186072, blue: 0.5054938793, alpha: 1)))
                .border(Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1)), width: 0.25)
                .clipped()
            
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .font(.caption).bold()
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Text(price).font(.system(size: 14))
                        .frame(width: 100, height: 25)
                        .modifier(RoundedGradientViewModifier())
                        .padding(.top, 5)
                }
                
                Text(subtitle)
                    .font(.caption)
            }
        }
        .frame(height: 50)
    }
}

struct OrderCell_Previews: PreviewProvider {
    static var previews: some View {
        OrderCell(title: "Restaurant rustica rustica", subtitle: " 22.10.2021. at 13:00 ", price: "100 HRK", isActive: true)
    }
}
