//
//  SearchCell.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 26.07.2021..
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchCell: View {
    
    let title: String
    let imageURL: URL?
    
    
    var body: some View {
        HStack(spacing: 0) {
            WebImage(url: imageURL)
                .resizable()
                .placeholder {
                    Image(.person)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.all, 5)
                        .frame(width: 80, height: 80, alignment: .center)
                        .background(Color(#colorLiteral(red: 0.9646247029, green: 0.9647596478, blue: 0.9645821452, alpha: 1)))
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .background(Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1)))
                .clipped()
            
            VStack(spacing: 0) {
                Text(title)
                    .font(.body).bold()
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding(.all, 5)
        }
        .frame(height: 80)
    }
}

struct SearchCell_Previews: PreviewProvider {
    static var previews: some View {
        SearchCell(title: "Title", imageURL: URL(string: "https://png.pngitem.com/pimgs/s/111-1114675_user-login-person-man-enter-person-login-icon.png"))
    }
}
