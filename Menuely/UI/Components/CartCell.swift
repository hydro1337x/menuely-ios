//
//  CartCell.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 09.08.2021..
//

import SwiftUI
import SDWebImageSwiftUI

struct CartCell: View {
    
    let imageURL: URL?
    let title: String
    let price: String
    let quantity: String
    let incrementAction: () -> Void
    let decrementAction: () -> Void
    
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
                    
                    Spacer()
                    
                    Button(action: incrementAction, label: {
                        Image(.plus)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                    })
                    .frame(width: 44, height: 44)
                    .buttonStyle(RoundedGradientButtonStyle())
                    
                    Button(action: decrementAction, label: {
                        Image(.minus)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                    })
                    .frame(width: 44, height: 44)
                    .buttonStyle(RoundedGradientButtonStyle())
                    .padding(.leading, 5)
                }
                .padding(.top, 5)
            }
        }
        .frame(height: 100)
    }
}

struct CartCell_Previews: PreviewProvider {
    static var previews: some View {
        CartCell(imageURL: URL(string: "https://fh-sites.imgix.net/sites/4200/2016/11/12155048/wheredidbeeroriginatefrom.jpg?auto=compress%2Cformat&w=1000&h=1000&fit=max"), title: "BeerBeerBeerBeer", price: "100 HRK", quantity: "5", incrementAction: {}, decrementAction: {})
    }
}
