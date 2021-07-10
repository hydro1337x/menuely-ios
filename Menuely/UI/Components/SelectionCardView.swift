//
//  SelectionCardView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 10.07.2021..
//

import SwiftUI

struct SelectionCardView: View {
    let imageName: Image.ImageName
    let text: String
    
    var body: some View {
        Group {
            HStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32, alignment: .leading)
                Spacer()
                Text(text)
                    .offset(x: -16, y: 0)
                Spacer()
            }
            .padding(.horizontal, 30)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 85)
        .background(Color(#colorLiteral(red: 0.8979633451, green: 0.8980894089, blue: 0.8979235291, alpha: 1)))
        .cornerRadius(10)
    }
}

struct SelectionCardView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionCardView(imageName: .person, text: "Private person")
    }
}
