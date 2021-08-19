//
//  InvitationCell.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.08.2021..
//

import SwiftUI
import SDWebImageSwiftUI

struct InvitationCell: View {
    
    let title: String
    let imageURL: URL?
    let primaryAction: (() -> Void)
    let primaryButtonTitle: String
    let secondaryAction: (() -> Void)?
    let secondaryButtonTitle: String?
    
    
    var body: some View {
        HStack(spacing: 0) {
            WebImage(url: imageURL)
                .resizable()
                .placeholder {
                    Image(.person)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.all, 5)
                        .frame(width: 80, height: 80)
                        .background(Color(#colorLiteral(red: 0.9646247029, green: 0.9647596478, blue: 0.9645821452, alpha: 1)))
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .background(Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1)))
                .clipped()
            
            VStack(spacing: 0) {
                Text(title)
                    .font(.body).bold()
                    .frame(maxWidth: .infinity)
                
                HStack {
                    Button(action: primaryAction, label: {
                        Text(primaryButtonTitle)
                    })
                    .frame(width: 100, height: 30)
                    .buttonStyle(RoundedGradientButtonStyle())
                    
                    if let secondaryAction = self.secondaryAction, let secodndaryButtonTitle = self.secondaryButtonTitle {
                        Button(action: secondaryAction, label: {
                            Text(secodndaryButtonTitle)
                        })
                        .frame(width: 100, height: 30)
                        .buttonStyle(RoundedGradientButtonStyle())
                    }
                }
                .padding(.vertical, 5)
                
            }
            .frame(maxWidth: .infinity)
            .padding(.all, 5)
        }
        .frame(height: 80)
    }
}

struct InvitationCell_Previews: PreviewProvider {
    static var previews: some View {
        InvitationCell(title: "Title", imageURL: URL(string: "https://png.pngitem.com/pimgs/s/111-1114675_user-login-person-man-enter-person-login-icon.png"), primaryAction: {}, primaryButtonTitle: "Accept", secondaryAction: {}, secondaryButtonTitle: "Decline")
    }
}
