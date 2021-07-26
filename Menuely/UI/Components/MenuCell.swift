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
    let imageName: Image.ImageName
    
    var body: some View {
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
        .frame(maxHeight: 250)
    }
}

struct MenuCell_Previews: PreviewProvider {
    static var previews: some View {
        MenuCell(title: "Title", description: "Description", imageName: .menu)
    }
}
