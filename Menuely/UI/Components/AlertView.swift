//
//  AlertView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 12.07.2021..
//

import SwiftUI

struct AlertView: View {
    
    let title: String
    let message: String?
    let primaryButton: Button<Text>?
    let secondaryButton: Button<Text>?
    
    var body: some View {
        VStack {
            VStack {
                Text(title)
                    .scaledFont(.title3)
                
                if let message = message {
                    Text(message)
                        .scaledFont(.callout)
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
