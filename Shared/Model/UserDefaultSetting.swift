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

    @UserDefault(key: "lightModeColor", defaultValue: DefaultLightModeColor)
    var lightModeColor: Color

    @UserDefault(key: "darkModeColor", defaultValue: DefaultDarkModeColor)
    var darkModeColor: Color

    @UserDefault(key: "boardSize", defaultValue: DefaultBoardSize)
    var boardSize: Int
}
