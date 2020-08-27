//
//  SettingEnvironment.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/25.
//

import SwiftUI
import Combine

// TODO: もう少しうまくやれそうな気もする。というかこのクラスが過剰になるのでは？
//
// 以下の実装パターンがよさそう。
// https://fivestars.blog/swiftui/app-scene-storage.html

final class SettingEnvironment: ObservableObject {
    static let shared: SettingEnvironment = .init()
    
    @Published var darkModeColor: Color
    @Published var lightModeColor: Color
    @Published var boardSize: Int
    @Published var animationSpeed: Double
    @Published var zoomLevel: Int
    @Published var boardSelectDisplayStyle: BoardSelectStyle
    @Published var isFilterByStared: Bool

    #if os(iOS)
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
        
        // FIXME: 背景画像が復元されない。
        #warning("FIXME: 背景画像が起動時に復元されない（読み取れない）不具合あり。アプリ側のバグの可能性が高く感じるが、現時点ではOS側のバグも考慮。（beta 6）")
        
        #if os(iOS)
        AppLogger.imageLoadBug.notice("[Start] loading background image.")
        let image = UserDefaultSetting.shared.backgroundImage.image
        backgroundImage = image
        AppLogger.imageLoadBug.notice("[End] loading background image: \(image == nil ? "nil" : "found!", privacy: .public)")
        #endif

        boardSelectDisplayStyle = UserDefaultSetting.shared.boardSelectDisplayStyle
        isFilterByStared = UserDefaultSetting.shared.isFilterByStared

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
        
        #if os(iOS)
        $backgroundImage
            .dropFirst()
            .map(UIImageWrapper.init)
            .assign(to: \.backgroundImage, on: UserDefaultSetting.shared)
            .store(in: &cancellables)
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
