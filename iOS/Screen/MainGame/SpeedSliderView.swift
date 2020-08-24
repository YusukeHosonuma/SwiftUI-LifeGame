//
//  SpeedSliderView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/02.
//

import SwiftUI

struct SpeedSliderView: View {
    @EnvironmentObject var setting: SettingEnvironment
    @EnvironmentObject var gameManager: GameManager

    var body: some View {
        HStack {
            Image(systemName: "tortoise.fill")
            Slider(value: $gameManager.speed, in: 0...1, onEditingChanged: gameManager.speedChanged)
            Image(systemName: "hare.fill")
            Stepper(value: $setting.zoomLevel, in: 0...10) {}
        }
        .foregroundColor(.accentColor)
    }
}
