//
//  OrderPreviewCell.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 14.08.2021..
//

import SwiftUI
import SDWebImageSwiftUI

struct OrderPreviewCell: View {
    let imageURL: URL?
    let title: String
    let price: String
    let quantity: String
    
    var body: some View {
        HStack(alignment: .top) {
            WebImage(url: imageURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipped()
            
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .font(.body).bold()
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Button(action: {}, label: {
                        Text(price).font(.system(size: 14))
                    })
                    .frame(width: 100, height: 25)
                    .buttonStyle(RoundedGradientButtonStyle())
                    .disabled(true)
                    .padding(.top, 5)
                }
                
                HStack {
                    Text("Quantity: \(quantity)")
                }
                .padding(.top, 5)
            }
        }
        .frame(height: 100)
    }
}

struct OrderPreviewCell_Previews: PreviewProvider {
    static var previews: some View {
        OrderPreviewCell(imageURL: URL(string: "https://fh-sites.imgix.net/sites/4200/2016/11/12155048/wheredidbeeroriginatefrom.jpg?auto=compress%2Cformat&w=1000&h=1000&fit=max"), title: "BeerBeerBeerBeer", price: "100 HRK", quantity: "5")
    }
}
