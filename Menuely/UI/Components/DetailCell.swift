//
//  DetailCell.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 02.08.2021..
//

import SwiftUI

struct DetailCell: View {
    
    let title: String
    let text: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body).bold()
            
            Spacer()
            
            Text(text)
                .font(.body)
        }
        .frame(height: 44)
    }
}

struct DetailCell_Previews: PreviewProvider {
    static var previews: some View {
        DetailCell(title: "Title", text: "Text")
    }
}
