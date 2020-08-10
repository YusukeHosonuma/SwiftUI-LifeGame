//
//  UserDefaultSetting.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/01.
//

import SwiftUI

final class UserDefaultSetting {
    static let shared = UserDefaultSetting()
        
    static let DefaultLightModeColor: Color = .black
    static let DefaultDarkModeColor: Color = .white
    static let DefaultBoardSize: Int = 13
    static let DefaultAnimationSpeed: Double = 0.5
    static let DefaultZoomLevel: Int = 5
    
    #if os(iOS)
    static let DefaultBoardSelectDisplayStyle: BoardSelectStyle = .grid
    #endif

    @UserDefault(key: "lightModeColor", defaultValue: DefaultLightModeColor)
    var lightModeColor: Color

    @UserDefault(key: "darkModeColor", defaultValue: DefaultDarkModeColor)
    var darkModeColor: Color

    @UserDefault(key: "boardSize", defaultValue: DefaultBoardSize)
    var boardSize: Int

    @UserDefault(key: "animationSpeed", defaultValue: DefaultAnimationSpeed)
    var animationSpeed: Double

    @UserDefault(key: "zoomLevel", defaultValue: DefaultZoomLevel)
    var zoomLevel: Int
    
    #if os(iOS)
    @UserDefault(key: "boardSelectDisplayStyle", defaultValue: DefaultBoardSelectDisplayStyle)
    var boardSelectDisplayStyle: BoardSelectStyle
    #endif
}
