//
//  SpeedSliderView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/02.
//

import SwiftUI

private let scales: [Int] = [75, 100, 125]

struct SpeedSliderView: View {
    @EnvironmentObject var setting: SettingEnvironment
    @EnvironmentObject var gameManager: GameManager

    var body: some View {
        HStack {
            SpeedControlView(speed: $gameManager.speed, onEditingChanged: gameManager.speedChanged)
                .padding(.trailing, 40)
            
            ScaleChangeButton(scale: $gameManager.scale)
        }
    }
}

struct SpeedSliderView_Previews: PreviewProvider {
    static var previews: some View {
        SpeedSliderView()
            .previewLayout(.sizeThatFits)
            .padding()
            .environmentObject(SettingEnvironment.shared)
            .environmentObject(GameManager.shared)
    }
}
