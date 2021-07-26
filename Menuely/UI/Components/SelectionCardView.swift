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
                    .frame(width: 40, height: 40, alignment: .center)
                    .foregroundColor(Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1)))
                Spacer()
                Text(text)
                    .font(.title2)
                    .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                    .offset(x: -16, y: 0)
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 85)
    }
}

struct SelectionCardView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionCardView(imageName: .person, text: "Private person")
    }
}
