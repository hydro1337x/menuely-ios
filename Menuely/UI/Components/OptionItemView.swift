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
                .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
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
