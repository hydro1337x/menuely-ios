//
//  AlertView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 12.07.2021..
//

import SwiftUI

struct AlertViewConfiguration {
    var titleTextStyle: Font.TextStyle = .title3
    var messageTextStyle: Font.TextStyle = .callout
    var blurredBackground: Color = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    var alertBackground: Color = Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1))
    var backgroundCornerRadius: CGFloat = 10
}

struct AlertView: View {
    
    let title: String
    let message: String?
    let primaryButton: Button<Text>?
    let secondaryButton: Button<Text>?
    
    var configuration: AlertViewConfiguration = AlertViewConfiguration()
    
    var body: some View {
        ZStack {
            
            configuration.blurredBackground
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.8)
                .blur(radius: 200)
            
            VStack {
                VStack(spacing: 0) {
                    Text(title)
                        .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                        .scaledFont(configuration.titleTextStyle)
                        .padding(.horizontal, 15)
                        .padding(.top, 10)
                    
                    if let message = message {
                        Text(message)
                            .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                            .scaledFont(configuration.messageTextStyle)
                            .padding(.top, 5)
                            .padding(.horizontal, 15)
                    }
                    
                    Divider()
                        .padding(.top, 10)
                    
                    GeometryReader(content: { geometry in
                        HStack(spacing: 0) {
                            primaryButton
                                .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                                .frame(width: geometry.size.width / 2, height: 48)
                            Divider()
                                .frame(height: 30)
                            secondaryButton
                                .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                                .frame(width: geometry.size.width / 2, height: 48)
                        }
                    })
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 5)
                    
                }
            }
            .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)).opacity(0.3), radius: 5, x: 0, y: 5)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.1), radius: 2, x: 0, y: 2)
            .padding(.horizontal, 30)
        }
        
        
    }
}


struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(title: "Title", message: "MessagfwafwafawfwafafwaMessagfwafwafawfwafafwaMessagfwafwafawfwafafwaMessagfwafwafawfwafafwaMessagfwafwafawfwafafwaMessagfwafwafawfwafafwaMessagfwafwafawfwafafwaMessagfwafwafawfwafafwa", primaryButton: Button(action: {}, label: {
            Text("Button")
        }), secondaryButton: Button(action: {}, label: {
            Text("Button")
        }))
    }
}
