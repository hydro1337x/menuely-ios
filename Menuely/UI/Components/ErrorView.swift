//
//  ErrorView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 12.07.2021..
//

import SwiftUI

struct ErrorView: View {
    @Binding var animate: Bool
    let message: String
    let action: () -> Void
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    Text("Something went wrong")
                        .scaledFont(.body)
                    
                    Divider()
                    
                    Text(message)
                        .scaledFont(.callout)
                        .padding(.top, 5)
                }
                .padding(.all, 10)
            }
            .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(.horizontal, 30)
            .scaleEffect(animate ? 1 : 0.5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.2))
        .ignoresSafeArea(.all)
        .opacity(animate ? 1 : 0)
        .onTapGesture {
            action()
        }
        .animation(.easeInOut(duration: 0.2))
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(animate: .constant(false), message: "Error message", action: {})
    }
}
