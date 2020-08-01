//
//  SettingEnvironment.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/25.
//

import SwiftUI
import Combine

// TODO: もう少しうまくやれそうな気もする。というかこのクラスが過剰になるのでは？

final class SettingEnvironment: ObservableObject {
    static let shared: SettingEnvironment = .init()
    
    @Published var darkModeColor: Color
    @Published var lightModeColor: Color
    @Published var boardSize: Int
    @Published var animationSpeed: Double
    @Published var zoomLevel: Int

    private var cancellables: [AnyCancellable] = []
    
    init() {
        // Restore
        lightModeColor = UserDefaultSetting.shared.lightModeColor
        darkModeColor = UserDefaultSetting.shared.darkModeColor
        boardSize = UserDefaultSetting.shared.boardSize
        animationSpeed = UserDefaultSetting.shared.animationSpeed
        zoomLevel = UserDefaultSetting.shared.zoomLevel

        // Subscribe changes
        $lightModeColor
            .dropFirst()
            .assign(to: \.lightModeColor, on: UserDefaultSetting.shared)
            .store(in: &cancellables)
        $darkModeColor
            .dropFirst()
            .assign(to: \.darkModeColor, on: UserDefaultSetting.shared)
            .store(in: &cancellables)
        $boardSize
            .dropFirst()
            .assign(to: \.boardSize, on: UserDefaultSetting.shared)
            .store(in: &cancellables)
        $animationSpeed
            .dropFirst()
            .assign(to: \.animationSpeed, on: UserDefaultSetting.shared)
            .store(in: &cancellables)
        $zoomLevel
            .dropFirst()
            .assign(to: \.zoomLevel, on: UserDefaultSetting.shared)
            .store(in: &cancellables)
    }
    
    func resetToDefault() {
        lightModeColor = UserDefaultSetting.DefaultLightModeColor
        darkModeColor = UserDefaultSetting.DefaultDarkModeColor
        boardSize = UserDefaultSetting.DefaultBoardSize
        animationSpeed = UserDefaultSetting.DefaultAnimationSpeed
        zoomLevel = UserDefaultSetting.DefaultZoomLevel
    }
}
