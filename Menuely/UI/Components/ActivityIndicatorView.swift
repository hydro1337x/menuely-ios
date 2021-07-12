//
//  ActivityIndicatorView.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 13.07.2021..
//

import SwiftUI

struct ActivityIndicatorConfiguration {
  var spinnerColor: Color = Color(#colorLiteral(red: 0.3146468997, green: 0.7964186072, blue: 0.5054938793, alpha: 1))
  var blurredBackground: Color = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
  var spinnerBackgroundColor: Color = Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1))
  var backgroundCornerRadius: CGFloat = 30
  var width: CGFloat = 50
  var height: CGFloat = 50
  var velocity: Double = 1
}

struct ActivityIndicatorView: View {
 
    var configuration: ActivityIndicatorConfiguration = ActivityIndicatorConfiguration()
    @State var isAnimating = false
    
    var body: some View {
        let multiplier = configuration.width / 40
        
        return
            ZStack {
                configuration.blurredBackground.opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 200)
                
                ZStack {
                    configuration.spinnerBackgroundColor.opacity(0.5)
                    
                    Circle()
                        .trim(from: 0.2, to: 1)
                        .stroke(
                            configuration.spinnerColor,
                            style: StrokeStyle(
                                lineWidth: 5 * multiplier,
                                lineCap: .round
                            )
                        )
                        .frame(width: configuration.width, height: configuration.height)
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 3)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(
                            Animation.linear(duration: configuration.velocity)
                                .repeatForever(autoreverses: false)
                        )
                }
                .frame(width: 80 * multiplier, height: 80 * multiplier)
                .background(Color.white)
                .cornerRadius(configuration.backgroundCornerRadius)
                .shadow(color: Color.white.opacity(0.3), radius: 5, x: 0, y: 5)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                .onAppear {
                    self.isAnimating = true
                }
            }
    }
}

struct ActivityIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicatorView()
    }
}
