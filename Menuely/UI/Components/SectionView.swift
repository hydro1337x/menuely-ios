//
//  SectionView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.08.2021..
//

import SwiftUI

struct SectionView<Content: View>: View {
    
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title.uppercased())
                .font(.caption).foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
            
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 0) {
                    content
                        .padding(.horizontal, 10)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
            .cornerRadius(10)
            .padding(.vertical, 10)
        }
        .padding(.horizontal, 16)
        
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView(title: "Title") {
            Text("First text")
            Text("Second text")
        }
    }
}
