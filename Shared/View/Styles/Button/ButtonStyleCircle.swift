//
//  CircleStyle.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/16.
//

import SwiftUI

struct ButtonStyleCircle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(configuration: configuration)
    }
    
    struct Button: View {
        var configuration: Configuration
        var foreground = Color.white
        var background = Color.accentColor
        
        var borderColor: Color {
            colorScheme == .dark ? Color.black : Color.white
        }
        
        @Environment(\.colorScheme) private var colorScheme: ColorScheme
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var body: some View {
            Circle()
                .fill(background.opacity(!isEnabled ? 0.5 : configuration.isPressed ? 0.8 : 1))
                .overlay(Circle().strokeBorder(borderColor, lineWidth: 2).padding(2))
                .overlay(configuration.label.foregroundColor(foreground))
                .frame(width: 64, height: 64)
        }
    }
}

struct ButtonStyleCircleStyle_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Button("Start") {}
            Button("Stop") {}.disabled(true)
        }
        .buttonStyle(ButtonStyleCircle())
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
