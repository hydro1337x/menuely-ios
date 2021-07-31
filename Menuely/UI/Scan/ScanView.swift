//
//  ScanView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 25.07.2021..
//

import SwiftUI
import CodeScanner

struct ScanView: View {
    @InjectedObservedObject private var viewModel: ScanViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                CodeScannerView(codeTypes: [.qr], scanMode: .continuous, scanInterval: 2) { result in
                    print(result)
                }
                .frame(width: 250, height: 250, alignment: .center)
                .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(#colorLiteral(red: 0.3146468997, green: 0.7964186072, blue: 0.5054938793, alpha: 1)), lineWidth: 5))
            }
        }
    }
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView()
    }
}
