//
//  SearchCell.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 26.07.2021..
//

import SwiftUI

struct SearchCell: View {
    var body: some View {
        HStack(spacing: 0) {
            Image(.person)
                .resizable()
                .aspectRatio(contentMode: .fit)
            VStack(spacing: 0) {
                Text("Title")
                    .font(.body).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Description")
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.all, 5)
        }
        .frame(height: 80)
        .background(Color(#colorLiteral(red: 0.9646247029, green: 0.9647596478, blue: 0.9645821452, alpha: 1)))
    }
}

struct SearchCell_Previews: PreviewProvider {
    static var previews: some View {
        SearchCell()
    }
}
