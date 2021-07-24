//
//  InfoView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 12.07.2021..
//

import SwiftUI
import Resolver

struct InfoViewStyle {
    var titleTextStyle: Font = .body
    var messageTextStyle: Font = .callout
    var blurredBackground: Color = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    var background: Color = Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1))
    var backgroundCornerRadius: CGFloat = 10
}

struct InfoViewConfiguration: Equatable {
    let title: String
    let message: String?
}

struct InfoView: View {
    
    @InjectedObservedObject private var viewModel: ViewModel
    
    var style: InfoViewStyle = InfoViewStyle()
    
    var body: some View {
        ZStack {
            
            style.blurredBackground
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.3)
                .onTapGesture {
                    viewModel.appState[\.routing.info.configuration] = nil
                }
                
            
            VStack {
                VStack {
                    Text(viewModel.routing.configuration?.title ?? "")
                        .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                        .padding(.top, 5)
                        .font(style.titleTextStyle)
                    
                    Divider()
                        .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                    
                    Text(viewModel.routing.configuration?.message ?? "")
                        .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                        .font(style.messageTextStyle)
                        .padding(.vertical, 5)
                }
                .padding(.all, 15)
            }
            .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: style.backgroundCornerRadius, style: .continuous))
            .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)).opacity(0.3), radius: 5, x: 0, y: 5)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.1), radius: 2, x: 0, y: 2)
            .padding(.horizontal, 30)
            .scaleEffect(viewModel.routing.configuration != nil ? 1 : 0.5)
        }
        .opacity(viewModel.routing.configuration != nil ? 1 : 0)
        .animation(.easeInOut(duration: 0.2))
        
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}

extension InfoView {
    class ViewModel: ObservableObject {
        @Published var routing: Routing
        
        var appState: Store<AppState>
        var cancelBag = CancelBag()
        
        init(appState: Store<AppState>) {
            self.appState = appState
            
            _routing = .init(initialValue: appState[\.routing.info])
            
            cancelBag.collect {
                
                $routing
                    .removeDuplicates()
                    .sink { appState[\.routing.info] = $0 }
                
                appState
                    .map(\.routing.info)
                    .removeDuplicates()
                    .assign(to: \.routing, on: self)
            }
        }
    }
    
    struct Routing: Equatable {
        var configuration: InfoViewConfiguration?
    }
}
