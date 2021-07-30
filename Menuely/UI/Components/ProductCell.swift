//
//  ProductCell.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 30.07.2021..
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductCell: View {
    @State private var isTapped: Bool = false
    
    private let baseHeight: CGFloat = 100
    private let extendedHeight: CGFloat = 400
    private let horizontalShift: CGFloat = 80
    private let extendedImageHeight: CGFloat = 225
    private let imageVerticalOffset: CGFloat = 225/2
    private var buttonVerticalOffset: CGFloat {
        return (125 / 2) - 30
    }
    
    func descriptionWidth(for frameWidth: CGFloat) -> CGFloat {
        let value = frameWidth - horizontalShift - baseHeight
        return abs(value)
    }
    
    var body: some View {
        GeometryReader() { geometry in
            WebImage(url: URL(string: imageURL))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: isTapped ? geometry.size.width : baseHeight, height: isTapped ? extendedImageHeight : baseHeight)
//                .offset(y: isTapped ? -imageVerticalOffset : 0)
                .clipped()
            
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Title")
                        .font(.body).bold().foregroundColor(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
                    
                    Text("Lorem ipsum dorem lorem ispum daloren endorem lorem sumorenLorem ipsum dorem lorem ispum daloren endorem lorem sumorenLorem ipsum dorem lorem ispum daloren")
                        .font(.callout).foregroundColor(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
                        .frame(width: isTapped ? geometry.size.width : descriptionWidth(for: geometry.size.width))
                }
                .offset(x: isTapped ? 0 : baseHeight)
                
                Button(action: {
                    
                }, label: {
                    Text(isTapped ? "Add to cart (10 HRK)" : "10 HRK")
                })
                .frame(width: isTapped ? geometry.size.width : 80, height: isTapped ? 50 : 30 )
                .background(Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)))
                .offset(x: isTapped ? 0 : geometry.size.width - horizontalShift, y: isTapped ? 0 : -buttonVerticalOffset)
            }
            .padding(.top, isTapped ? extendedImageHeight : 0)
            
            
        }
        .frame(height: isTapped ? extendedHeight : baseHeight)
        .animation(.spring(response: 0.3, dampingFraction: 0.5))
        .onTapGesture {
            isTapped.toggle()
        }
    }
}

struct ProductCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductCell()
    }
}
