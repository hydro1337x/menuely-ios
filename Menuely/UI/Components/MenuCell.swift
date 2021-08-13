//
//  MenuCell.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 26.07.2021..
//

import SwiftUI

struct MenuCell: View {
    let title: String
    let description: String
    let imageName: ImageName
    let isActive: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                    
                    Text(title)
                        .font(.body).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                        .lineLimit(2)
                }
                
                Text(description)
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 5)
            }
            
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(isActive ? Color(#colorLiteral(red: 0.3146468997, green: 0.7964186072, blue: 0.5054938793, alpha: 1)) : Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1)))
                .frame(width: 8, height: 8)
                .offset(y: -22)
        }
        .frame(maxHeight: 250)
    }
}

struct MenuCell_Previews: PreviewProvider {
    static var previews: some View {
        MenuCell(title: "Title", description: "Description Description Description Description Description", imageName: .menu, isActive: true)
    }
}
