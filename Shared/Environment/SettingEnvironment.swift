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
    #if os(iOS)
    @Published var boardSelectDisplayStyle: BoardSelectStyle
    @Published var isFilterByStared: Bool
    #endif
    #if os(macOS)
    // TODO:
    #else
    @Published var backgroundImage: UIImage?
    #endif

    private var cancellables: [AnyCancellable] = []
    
    init() {
        // Restore
        lightModeColor = UserDefaultSettingGroup.shared.lightModeColor
        darkModeColor = UserDefaultSettingGroup.shared.darkModeColor
        boardSize = UserDefaultSetting.shared.boardSize
        animationSpeed = UserDefaultSetting.shared.animationSpeed
        zoomLevel = UserDefaultSetting.shared.zoomLevel
        backgroundImage = UserDefaultSetting.shared.backgroundImage.image

        #if os(iOS)
        boardSelectDisplayStyle = UserDefaultSetting.shared.boardSelectDisplayStyle
        isFilterByStared = UserDefaultSetting.shared.isFilterByStared
        #endif

        // App Groups
        
        $lightModeColor
            .dropFirst()
            .assign(to: \.lightModeColor, on: UserDefaultSettingGroup.shared)
            .store(in: &cancellables)
        $darkModeColor
            .dropFirst()
            .assign(to: \.darkModeColor, on: UserDefaultSettingGroup.shared)
            .store(in: &cancellables)
        
        // App only

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
        $backgroundImage
            .dropFirst()
            .map(UIImageWrapper.init)
            .assign(to: \.backgroundImage, on: UserDefaultSetting.shared)
            .store(in: &cancellables)
        
        #if os(iOS)
        $boardSelectDisplayStyle
            .dropFirst()
            .assign(to: \.boardSelectDisplayStyle, on: UserDefaultSetting.shared)
            .store(in: &cancellables)

        $isFilterByStared
            .dropFirst()
            .assign(to: \.isFilterByStared, on: UserDefaultSetting.shared)
            .store(in: &cancellables)
        #endif
    }
    
    func resetToDefault() {
        lightModeColor = UserDefaultSettingGroup.DefaultLightModeColor
        darkModeColor = UserDefaultSettingGroup.DefaultDarkModeColor
        boardSize = UserDefaultSetting.DefaultBoardSize
        animationSpeed = UserDefaultSetting.DefaultAnimationSpeed
        zoomLevel = UserDefaultSetting.DefaultZoomLevel
        
        #if os(iOS)
        boardSelectDisplayStyle = UserDefaultSetting.DefaultBoardSelectDisplayStyle
        isFilterByStared = UserDefaultSetting.DefaultIsFilterByStared
        #endif
    }
}
