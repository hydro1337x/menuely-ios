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
    private let extendedHeight: CGFloat = 385
    private let horizontalShift: CGFloat = 80
    private let extendedImageHeight: CGFloat = 225
    private let imageVerticalOffset: CGFloat = 225/2
    private let buttonHeight: CGFloat = 30
    private let extendedButtonHeight: CGFloat = 50
    private let horizontalAdjustmentPadding: CGFloat = 5
    private var buttonVerticalOffset: CGFloat {
        return (baseHeight + buttonHeight) / 2
    }
    
    let title: String
    let description: String
    let price: String
    let imageURL: String
    
    func textVStackWidth(for frameWidth: CGFloat) -> CGFloat {
        let value = frameWidth - horizontalShift - (2 * horizontalAdjustmentPadding) - baseHeight
        return abs(value)
    }
    
    var textVStackHeight: CGFloat {
        if isTapped {
            return extendedHeight - extendedButtonHeight - extendedImageHeight
        } else {
            return baseHeight
        }
    }
    
    var body: some View {
        GeometryReader() { geometry in
            WebImage(url: URL(string: imageURL))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: isTapped ? geometry.size.width : baseHeight, height: isTapped ? extendedImageHeight : baseHeight)
                .cornerRadius(5)
                .clipped()
            
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                        .font(.body).bold()
                    
                    Text(description)
                        .font(.callout)
                    
                    Spacer()
                }
                .frame(width: isTapped ? geometry.size.width : textVStackWidth(for: geometry.size.width), height: textVStackHeight)
                .offset(x: isTapped ? 0 : baseHeight + horizontalAdjustmentPadding)
                
                Button(action: {
                    
                }, label: {
                    Text(isTapped ? "Add to cart (\(price))" : price)
                })
                .frame(width: isTapped ? geometry.size.width : 80, height: isTapped ? extendedButtonHeight : buttonHeight)
                .offset(x: isTapped ? 0 : geometry.size.width - horizontalShift, y: isTapped ? 0 : -buttonVerticalOffset)
                .buttonStyle(RoundedGradientButtonStyle())
            }
            .padding(.top, isTapped ? extendedImageHeight : 0)
            
        }
        .frame(height: isTapped ? extendedHeight : baseHeight)
        .padding(.horizontal, horizontalAdjustmentPadding)
        .animation(.spring(response: 0.35, dampingFraction: 0.7))
        .onTapGesture {
            isTapped.toggle()
        }
    }
}

struct ProductCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductCell(title: "Title", description: "Description", price: "4 €", imageURL: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjF8fHJlc3RhdXJhbnR8ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80")
    }
}
