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
                viewModel.routing.isOptionsSheetPresented = true
            }, label: {
                Image(.menu)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
            }))
            .sheet(isPresented: $viewModel.routing.isOptionsSheetPresented, content: {
                OptionsView()
            })
    }
}

extension ProfileView {
    struct Routing: Equatable {
        var isOptionsSheetPresented: Bool = false
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
