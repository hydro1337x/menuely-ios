//
//  ErrorView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 12.07.2021..
//

import SwiftUI

struct ErrorViewConfiguration {
    var titleTextStyle: Font.TextStyle = .body
    var messageTextStyle: Font.TextStyle = .callout
    var blurredBackground: Color = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    var background: Color = Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1))
    var backgroundCornerRadius: CGFloat = 10
}

struct ErrorView: View {
    @Binding var isAnimating: Bool
    let message: String
    let action: () -> Void
    
    var configuration: ErrorViewConfiguration = ErrorViewConfiguration()
    
    var body: some View {
        ZStack {
            
            configuration.blurredBackground
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.8)
                .blur(radius: 200)
                .onTapGesture {
                    action()
                }
                
            
            VStack {
                VStack {
                    Text("Something went wrong")
                        .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                        .padding(.top, 5)
                        .scaledFont(configuration.titleTextStyle)
                    
                    Divider()
                        .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                    
                    Text(message)
                        .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                        .scaledFont(configuration.messageTextStyle)
                        .padding(.vertical, 5)
                }
                .padding(.all, 15)
            }
            .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: configuration.backgroundCornerRadius, style: .continuous))
            .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)).opacity(0.3), radius: 5, x: 0, y: 5)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.1), radius: 2, x: 0, y: 2)
            .padding(.horizontal, 30)
            .scaleEffect(isAnimating ? 1 : 0.5)
        }
        .opacity(isAnimating ? 1 : 0)
        .animation(.easeInOut(duration: 0.2))
        
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(isAnimating: .constant(true), message: "Error message", action: {})
    }
}
