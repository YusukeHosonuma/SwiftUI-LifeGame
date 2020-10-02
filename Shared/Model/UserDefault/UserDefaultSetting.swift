//
//  UserDefaultSetting.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/01.
//

import SwiftUI

final class UserDefaultSetting {
    static let shared = UserDefaultSetting()
        
    static let DefaultBoardSize: Int = 32
    static let DefaultAnimationSpeed: Double = 0.5
    static let DefaultZoomLevel: Int = 5
    
    static let DefaultBoardSelectDisplayStyle: PatternSelectStyle = .grid
    static let DefaultIsFilterByStared: Bool = false

    @UserDefault(key: "boardSize", defaultValue: DefaultBoardSize)
    var boardSize: Int

    @UserDefault(key: "animationSpeed", defaultValue: DefaultAnimationSpeed)
    var animationSpeed: Double

    @UserDefault(key: "zoomLevel", defaultValue: DefaultZoomLevel)
    var zoomLevel: Int
    
    #if os(iOS)
    @UserDefault(key: "backgroundImage", defaultValue: UIImageWrapper(nil))
    var backgroundImage: UIImageWrapper
    #endif

    @UserDefault(key: "boardSelectDisplayStyle", defaultValue: DefaultBoardSelectDisplayStyle)
    var boardSelectDisplayStyle: PatternSelectStyle

    @UserDefault(key: "isFilterByStared", defaultValue: DefaultIsFilterByStared)
    var isFilterByStared: Bool
}
