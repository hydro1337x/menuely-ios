//
//  SelectionCardView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 10.07.2021..
//

import SwiftUI

struct SelectionCardView: View {
    // @GestureState property wrapper automatically resets the views state to false after the gesture ends
    @GestureState private var isTouchedDown: Bool = false
    let imageName: Image.ImageName
    let text: String
    
    
    var body: some View {
        let touchDownGesture = DragGesture(minimumDistance: 0)
            .updating($isTouchedDown) { (_, isTouchedDown, _) in
                isTouchedDown = true
            }
        
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
        .background(isTouchedDown ? Color(#colorLiteral(red: 0.9646247029, green: 0.9647596478, blue: 0.9645821452, alpha: 1)).opacity(1) : Color(#colorLiteral(red: 0.9646247029, green: 0.9647596478, blue: 0.9645821452, alpha: 1)).opacity(0.9))
        .cornerRadius(10)
        .scaleEffect(isTouchedDown ? 0.99 : 1)
        .shadow(radius: isTouchedDown ? 1 : 2)
        .gesture(touchDownGesture)
        .animation(.easeInOut(duration: 0.2))
    }
}

struct SelectionCardView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionCardView(imageName: .person, text: "Private person")
    }
}
