//
//  AccountInfoView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 21.07.2021..
//

import SwiftUI

struct AccountInfoView: View {
    let title: String
    let body1: String
    let body2: String
    let imageName: Image.ImageName
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(title)
                        .font(.body).bold()
                        .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                    
                    Spacer()
                }
                
                HStack {
                    Text(body1)
                        .font(.caption)
                        .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                    
                    Spacer()
                }
                
                HStack {
                    Text(body2)
                        .font(.caption)
                        .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                    
                    Spacer()
                }
            }
            
            Spacer()
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 5)
    }
}

struct AccountInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AccountInfoView(title: "Account info:", body1: "Created: 15.02.2020", body2: "Created: 15.02.2020", imageName: .person)
    }
}
