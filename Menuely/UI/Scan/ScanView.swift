//
//  ScanView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 25.07.2021..
//

import SwiftUI
import CodeScanner
import Resolver

struct ScanView: View {
    @StateObject private var viewModel: ScanViewModel = Resolver.resolve()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(#colorLiteral(red: 0.948246181, green: 0.9496578574, blue: 0.9691624045, alpha: 1))
                    .edgesIgnoringSafeArea(.all)
                
                content
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

extension ScanView {
    var content: some View {
        VStack {
            CodeScannerView(codeTypes: [.qr], scanMode: .continuous, scanInterval: 2) { result in
                switch result {
                case .success(let code):
                    viewModel.restaurantNoticeView(with: code)
                case .failure(let error):
                    viewModel.errorView(with: error.localizedDescription)
                }
            }
            .frame(width: 250, height: 250, alignment: .center)
            .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(#colorLiteral(red: 0.3146468997, green: 0.7964186072, blue: 0.5054938793, alpha: 1)), lineWidth: 5))
        }
        .offset(y: -50)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("Scan")
        .sheet(isPresented: viewModel.routing.menuForScannedRestaurantID == nil ? .constant(false) : .constant(true), onDismiss: {
            viewModel.routing.menuForScannedRestaurantID = nil
        }, content: {
            RestaurantNoticeView()
                .modifier(PopoversViewModifier())
                .modifier(RootViewAppearance())
        })
    }
}

extension ScanView {
    struct Routing: Equatable {
        var menuForScannedRestaurantID: Int?
    }
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView()
    }
}
