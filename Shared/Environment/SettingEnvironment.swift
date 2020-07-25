//
//  SettingEnvironment.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/25.
//

import SwiftUI
import Combine

// TODO: refactor - more swifty
private let KeyLightModeColor = "lightModeColor"
private let KeyDarkModeColor = "darkModeColor"

private let LightModeDefaultColor = Color.black
private let DarkModeDefaultColor = Color.white

final class SettingEnvironment: ObservableObject {
    @Published var darkModeColor: Color
    @Published var lightModeColor: Color
    
    private var cancellables: [AnyCancellable] = []
    
    init() {
        // Restore or use default color
        lightModeColor = UserDefaults.standard.data(forKey: KeyLightModeColor).flatMap(Color.init) ?? LightModeDefaultColor
        darkModeColor = UserDefaults.standard.data(forKey: KeyDarkModeColor).flatMap(Color.init) ?? DarkModeDefaultColor

        // Subscribe changes
        $lightModeColor
            .dropFirst()
            .sink {
                UserDefaults.standard.set($0.rawValue, forKey: KeyLightModeColor)
            }
            .store(in: &cancellables)
        $darkModeColor
            .dropFirst()
            .sink {
                UserDefaults.standard.set($0.rawValue, forKey: KeyDarkModeColor)
            }
            .store(in: &cancellables)
    }
    
    func resetToDefault() {
        lightModeColor = LightModeDefaultColor
        darkModeColor = DarkModeDefaultColor
    }
}

