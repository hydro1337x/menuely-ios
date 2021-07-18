//
//  ProfileView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 18.07.2021..
//

import SwiftUI

struct ProfileView: View {
    @InjectedObservedObject private var viewModel: ProfileViewModel
    
    var body: some View {
        Text("Profile")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.green)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Profile")
            .navigationBarItems(trailing: Button(action: {
                viewModel.appState[\.coordinating.profile] = .options
            }, label: {
                Image(.menu)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
            }))
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
