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
private let KeyBoardSize = "boardSize"

private let LightModeDefaultColor = Color.black
private let DarkModeDefaultColor = Color.white
private let DefaultBoardSize = 13

final class SettingEnvironment: ObservableObject {
    static let shared: SettingEnvironment = .init()
    
    @Published var darkModeColor: Color
    @Published var lightModeColor: Color
    @Published var boardSize: Int
    
    private var cancellables: [AnyCancellable] = []
    
    init() {
        // Register defaults
        UserDefaults.standard.register(defaults: [KeyBoardSize : DefaultBoardSize])

        // Restore
        lightModeColor = UserDefaults.standard.data(forKey: KeyLightModeColor).flatMap(Color.init) ?? LightModeDefaultColor
        darkModeColor = UserDefaults.standard.data(forKey: KeyDarkModeColor).flatMap(Color.init) ?? DarkModeDefaultColor
        boardSize = UserDefaults.standard.integer(forKey: KeyBoardSize)
        
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
        $boardSize
            .dropFirst()
            .sink {
                UserDefaults.standard.set($0, forKey: KeyDarkModeColor)
            }
            .store(in: &cancellables)
    }
    
    func resetToDefault() {
        lightModeColor = LightModeDefaultColor
        darkModeColor = DarkModeDefaultColor
    }
}

