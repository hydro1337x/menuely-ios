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
        VStack {
            VStack {
                Text(title)
                    .scaledFont(configuration.titleTextStyle)
                
                if let message = message {
                    Text(message)
                        .scaledFont(configuration.messageTextStyle)
                }
                
                HStack {
                    primaryButton
                    secondaryButton
                }
            }
            .padding(.all, 15)
        }
        .background(Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal, 30)
        
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
