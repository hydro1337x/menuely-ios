//
//  AlertView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 12.07.2021..
//

import SwiftUI

struct AlertViewStyle {
    var titleTextStyle: Font = .title3
    var messageTextStyle: Font = .callout
    var dimmedBackground: Color = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    var alertBackground: Color = Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1))
    var backgroundCornerRadius: CGFloat = 10
}

struct AlertViewConfiguration: Equatable {
    let title: String
    let message: String?
    let primaryAction: (() -> Void)
    let primaryButtonTitle: String
    let secondaryAction: (() -> Void)?
    let secondaryButtonTitle: String?
    
    static func == (lhs: AlertViewConfiguration, rhs: AlertViewConfiguration) -> Bool {
        return lhs.title == rhs.title && lhs.message == rhs.message
    }
}

struct AlertView: View {
    
    @InjectedObservedObject private var viewModel: ViewModel
    
    var style: AlertViewStyle = AlertViewStyle()
    
    var showSecondaryContent: Bool {
        guard viewModel.routing.configuration?.secondaryAction != nil, viewModel.routing.configuration?.secondaryButtonTitle != nil else { return false }
        return true
    }
    
    var body: some View {
        ZStack {
            
            style.dimmedBackground
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.3)
            
            VStack {
                VStack(spacing: 0) {
                    Text(viewModel.routing.configuration?.title ?? "")
                        .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                        .font(style.titleTextStyle)
                        .padding(.horizontal, 15)
                        .padding(.top, 10)
                    
                    if let message = viewModel.routing.configuration?.message {
                        Text(message)
                            .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                            .multilineTextAlignment(.center)
                            .font(style.messageTextStyle)
                            .padding(.top, 5)
                            .padding(.horizontal, 15)
                    }
                    
                    Divider()
                        .padding(.top, 10)
                    
                    GeometryReader(content: { geometry in
                        HStack(spacing: 0) {
                            Button(action: viewModel.routing.configuration?.primaryAction ?? {}, label: {
                                Text(viewModel.routing.configuration?.primaryButtonTitle ?? "")
                            })
                            .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                            .frame(width: showSecondaryContent ? geometry.size.width / 2 : geometry.size.width, height: 48)
                            
                            if showSecondaryContent {
                                
                                Divider()
                                    .frame(height: 30)
                                
                                Button(action: viewModel.routing.configuration?.secondaryAction ?? {}, label: {
                                    Text(viewModel.routing.configuration?.secondaryButtonTitle ?? "")
                                })
                                .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                                .frame(width: geometry.size.width / 2, height: 48)
                                
                            }
                        }
                    })
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 5)
                }
            }
            .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)).opacity(0.3), radius: 5, x: 0, y: 5)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.1), radius: 2, x: 0, y: 2)
            .padding(.horizontal, 30)
            .scaleEffect(viewModel.routing.configuration != nil ? 1 : 0.5)
        }
        .opacity(viewModel.routing.configuration != nil ? 1 : 0)
        .animation(.easeInOut(duration: 0.2))
    }
}


struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView()
    }
}

extension AlertView {
    class ViewModel: ObservableObject {
        
        @Published var routing: Routing
        
        var appState: Store<AppState>
        var cancelBag = CancelBag()
        
        init(appState: Store<AppState>) {
            self.appState = appState
            
            _routing = .init(initialValue: appState[\.routing.alert])
            
            cancelBag.collect {
                
                $routing
                    .removeDuplicates()
                    .sink { appState[\.routing.alert] = $0 }
                
                appState
                    .map(\.routing.alert)
                    .removeDuplicates()
                    .assign(to: \.routing, on: self)
            }
        }
        
    }
    
    struct Routing: Equatable {
        var configuration: AlertViewConfiguration?
    }
}
