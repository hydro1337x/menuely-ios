//
//  DescriptionView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 22.07.2021..
//

import SwiftUI

struct DescriptionView: View {
    let title: String
    let text: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(title)
                    .font(.body).bold().foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                    .padding(.top, 5)
                
                Spacer()
            }
            
            HStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    Text(text)
                        .font(.caption).foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                }
                
                Spacer()
            }
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: .infinity)
        .padding(.horizontal, 5)
        
            
    }
}

struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView(title: "Title", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
    }
}
