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
    @State private var descriptionSize: CGSize = .zero
    @State private var titleSize: CGSize = .zero
    
    private let baseHeight: CGFloat = 100
    private let horizontalShift: CGFloat = 100
    private let extendedImageHeight: CGFloat = 225
    private let imageVerticalOffset: CGFloat = 225/2
    private let buttonHeight: CGFloat = 25
    private let extendedButtonHeight: CGFloat = 50
    private let horizontalAdjustmentPadding: CGFloat = 5
    private let buttonWidth: CGFloat = 100
    private var buttonVerticalOffset: CGFloat {
        return descriptionSize.height + buttonHeight + 5
    }
    private var cellHeight: CGFloat {
        let extendedHeight = extendedImageHeight + 35 + titleSize.height + descriptionSize.height + buttonHeight
        return isTapped ? extendedHeight : baseHeight
    }
    
    let title: String
    let description: String
    let buttonTitle: String
    var extendedButtonTitle: String? = nil
    let imageURL: String
    var action: (() -> Void)? = nil
    
    func descriptionWidth(for frameWidth: CGFloat) -> CGFloat {
        let value = frameWidth - (2 * horizontalAdjustmentPadding) - baseHeight
        return abs(value)
    }
    
    func titleWidth(for frameWidth: CGFloat) -> CGFloat {
        let value = frameWidth - (2 * horizontalAdjustmentPadding) - baseHeight - buttonWidth
        return abs(value)
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
                    SizeReader(size: $titleSize) {
                        Text(title)
                            .font(.callout).bold()
                            .frame(width: isTapped ? geometry.size.width : titleWidth(for: geometry.size.width), alignment: .leading)
                    }
                    
                    SizeReader(size: $descriptionSize) {
                        Text(description)
                            .font(.caption)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(5)
                            .frame(width: isTapped ? geometry.size.width : descriptionWidth(for: geometry.size.width), alignment: .leading)
                    }
                }
                .offset(x: isTapped ? 0 : baseHeight + horizontalAdjustmentPadding)
                .padding(.vertical, 5)
                
                Button(action: {
                    action?()
                }, label: {
                    Text(isTapped ? extendedButtonTitle ?? buttonTitle : buttonTitle)
                        .font(isTapped ? .body : .system(size: 14))
                })
                .frame(width: isTapped ? geometry.size.width : buttonWidth, height: isTapped ? extendedButtonHeight : buttonHeight)
                .offset(x: isTapped ? 0 : geometry.size.width - horizontalShift, y: isTapped ? 0 : -buttonVerticalOffset)
                .buttonStyle(RoundedGradientButtonStyle())
                .disabled(action == nil ? true : false)
            }
            .padding(.top, isTapped ? extendedImageHeight : 0)
            
        }
        .frame(height: cellHeight)
        .padding(.horizontal, horizontalAdjustmentPadding)
        .animation(.spring(response: 0.35, dampingFraction: 0.7))
        .onTapGesture {
            isTapped.toggle()
        }
    }
}

struct ProductCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductCell(title: "Title", description: "Description", buttonTitle: "4 €", imageURL: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjF8fHJlc3RhdXJhbnR8ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80")
    }
}
