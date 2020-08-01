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
    
    private var cancellables: [AnyCancellable] = []
    
    init() {
        // Restore
        lightModeColor = UserDefaultSetting.shared.lightModeColor
        darkModeColor = UserDefaultSetting.shared.darkModeColor
        boardSize = UserDefaultSetting.shared.boardSize
        
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
    }
    
    func resetToDefault() {
        lightModeColor = UserDefaultSetting.DefaultLightModeColor
        darkModeColor = UserDefaultSetting.DefaultDarkModeColor
        boardSize = UserDefaultSetting.DefaultBoardSize
    }
}
