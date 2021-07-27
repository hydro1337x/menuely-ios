//
//  ActionView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 27.07.2021..
//

import SwiftUI

struct Action: Identifiable {
    var id = UUID()
    let name: String
    let handler: () -> Void
}

struct ActionViewStyle {
    var titleTextStyle: Font = .title3
    var actionTextStyle: Font = .callout
    var dimmedBackground: Color = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    var background: Color = Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1))
    var backgroundCornerRadius: CGFloat = 10
}

struct ActionViewConfiguration: Equatable {
    let title: String
    let actions: [Action]
    let onDismiss: (() -> Void)?
    
    static func == (lhs: ActionViewConfiguration, rhs: ActionViewConfiguration) -> Bool {
        return lhs.title == rhs.title
    }
}

struct ActionView: View {
    @InjectedObservedObject private var viewModel: ViewModel
    
    var style: AlertViewStyle = AlertViewStyle()
    
    var body: some View {
        ZStack {
            
            style.dimmedBackground
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.3)
                .onTapGesture {
                    viewModel.routing.configuration?.onDismiss?()
                    viewModel.routing.configuration = nil
                }
            
            VStack {
               
                Text(viewModel.routing.configuration?.title ?? "")
                    .foregroundColor(Color(#colorLiteral(red: 0.2980110943, green: 0.2980577946, blue: 0.2979964018, alpha: 1)))
                    .font(style.titleTextStyle)
                    .padding(.horizontal, 15)
                    .padding(.top, 10)
                
                Divider()
                
                if let actions = viewModel.routing.configuration?.actions {
                    ForEach(actions) { action in
                        Button(action: {
                            action.handler()
                        }, label: {
                            Text(action.name)
                        })
                        .frame(height: 48)
                        .padding(.top, 10)
                        .padding(.horizontal, 16)
                        .buttonStyle(RoundedGradientButtonStyle())
                    }
                    .padding(.bottom, 16)
                }
                
            }
            .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)).opacity(0.3), radius: 5, x: 0, y: 5)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.1), radius: 2, x: 0, y: 2)
            .padding(.horizontal, 16)
            .scaleEffect(viewModel.routing.configuration != nil ? 1 : 0.5)
        }
        .opacity(viewModel.routing.configuration != nil ? 1 : 0)
        .animation(.easeInOut(duration: 0.2))
    }
}

struct ActionView_Previews: PreviewProvider {
    static var previews: some View {
        ActionView()
    }
}

extension ActionView {
    class ViewModel: ObservableObject {
        
        @Published var routing: Routing
        
        var appState: Store<AppState>
        var cancelBag = CancelBag()
        
        init(appState: Store<AppState>) {
            self.appState = appState
            
            _routing = .init(initialValue: appState[\.routing.action])
            
            cancelBag.collect {
                
                $routing
                    .removeDuplicates()
                    .sink { appState[\.routing.action] = $0 }
                
                appState
                    .map(\.routing.action)
                    .removeDuplicates()
                    .assign(to: \.routing, on: self)
            }
        }
        
    }
    
    struct Routing: Equatable {
        var configuration: ActionViewConfiguration?
    }
}
