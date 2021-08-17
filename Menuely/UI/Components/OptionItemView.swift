//
//  OptionItemView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.07.2021..
//

import SwiftUI

struct OptionItemView: View {
    let option: OptionType
    let imageName: ImageName
    
    var body: some View {
        HStack {
            Text(option.rawValue)
                .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                .font(.body)
            Spacer()
                
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
    }
}

struct OptionItemView_Previews: PreviewProvider {
    static var previews: some View {
        OptionItemView(option: OptionType.updateProfile, imageName: .forwardArrow)
    }
}
