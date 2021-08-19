//
//  CategoryCell.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 29.07.2021..
//

import SwiftUI
import SDWebImageSwiftUI

struct CategoryCell: View {
    let title: String
    let imageUrl: String
    let placeholderImage: ImageName
    
    private let height: CGFloat = 125
    
    var body: some View {
        HStack(spacing: 0) {
            WebImage(url: URL(string: imageUrl))
                .resizable()
                .placeholder {
                    Image(placeholderImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.all, 5)
                        .frame(width: height, height: height, alignment: .center)
                        .background(Color(#colorLiteral(red: 0.9646247029, green: 0.9647596478, blue: 0.9645821452, alpha: 1)))
                        .foregroundColor(Color(#colorLiteral(red: 0.3146468997, green: 0.7964186072, blue: 0.5054938793, alpha: 1)))
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: height, height: height)
                .clipped()
            
            Spacer()
            
            Text(title)
                .font(.title2).bold().foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
            
            Spacer()
        }
        .frame(height: height)
    }
}

struct CategoryCell_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCell(title: "Title", imageUrl: "https://media-cdn.tripadvisor.com/media/photo-s/19/e1/63/dc/photo3jpg.jpg", placeholderImage: .logo)
    }
}
