//
//  SpeedControlView.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/27.
//

import SwiftUI

struct SpeedControlView: View {
    @Binding var speed: Double
    var onEditingChanged: (Bool) -> ()
    
    var body: some View {
        HStack {
            Image(systemName: "speedometer")
                .foregroundColor(.secondary)
                .font(.title2)
            
            Slider(value: $speed, in: 0...1, onEditingChanged: onEditingChanged)
        }
    }
}

struct SpeedControlView_Previews: PreviewProvider {
    static var previews: some View {
        SpeedControlView(speed: .constant(0.8), onEditingChanged: { _ in })
    }
}
