//
//  ActivityIndicatorView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 13.07.2021..
//

import SwiftUI

struct ActivityIndicatorStyle {
  var spinnerColor: Color = Color(#colorLiteral(red: 0.3146468997, green: 0.7964186072, blue: 0.5054938793, alpha: 1))
  var blurredBackground: Color = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
  var spinnerBackgroundColor: Color = Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1))
  var backgroundCornerRadius: CGFloat = 30
  var width: CGFloat = 50
  var height: CGFloat = 50
  var velocity: Double = 1
}

struct ActivityIndicatorView: View {
 
    @InjectedObservedObject private var viewModel: ViewModel
    
    @State private var isAnimating = false
    
    var style: ActivityIndicatorStyle = ActivityIndicatorStyle()
    
    var body: some View {
        let multiplier = style.width / 40
        
        return
            ZStack {
                style.blurredBackground.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                
                ZStack {
                    style.spinnerBackgroundColor.opacity(0.5)
                    
                    Circle()
                        .trim(from: 0.2, to: 1)
                        .stroke(
                            style.spinnerColor,
                            style: StrokeStyle(
                                lineWidth: 5 * multiplier,
                                lineCap: .round
                            )
                        )
                        .frame(width: style.width, height: style.height)
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 3)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(
                            Animation.linear(duration: style.velocity)
                                .repeatForever(autoreverses: false)
                        )
                }
                .frame(width: 80 * multiplier, height: 80 * multiplier)
                .background(Color.white)
                .cornerRadius(style.backgroundCornerRadius)
                .shadow(color: Color.white.opacity(0.3), radius: 5, x: 0, y: 5)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                .scaleEffect(viewModel.routing.isActive ? 1 : 0.5)
                .onAppear {
                    self.isAnimating = true
                }
            }
            .opacity(viewModel.routing.isActive ? 1 : 0)
            .animation(.easeInOut(duration: 0.2))
    }
}

struct ActivityIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicatorView()
    }
}

extension ActivityIndicatorView {
    
    class ViewModel: ObservableObject {
        @Published var routing: Routing
        
        var appState: Store<AppState>
        var cancelBag = CancelBag()
        
        init(appState: Store<AppState>) {
            self.appState = appState
            
            _routing = .init(initialValue: appState[\.routing.activityIndicator])
            
            cancelBag.collect {
                
                $routing
                    .removeDuplicates()
                    .sink { appState[\.routing.activityIndicator] = $0 }
                
                appState
                    .map(\.routing.activityIndicator)
                    .removeDuplicates()
                    .assign(to: \.routing, on: self)
            }
        }
    }
    
    struct Routing: Equatable {
        var isActive: Bool = false
    }
}
