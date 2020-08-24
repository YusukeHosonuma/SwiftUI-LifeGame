//
//  UserDefaultSettingGroup.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/12.
//

import SwiftUI

private let Suite = "group.lifegame"

final class UserDefaultSettingGroup {
    static let shared = UserDefaultSettingGroup()

    static let DefaultLightModeColor: Color = .black
    static let DefaultDarkModeColor: Color = .white

    @UserDefaultGroup(suite: Suite,  key: "lightModeColor", defaultValue: DefaultLightModeColor)
    var lightModeColor: Color

    @UserDefaultGroup(suite: Suite,  key: "darkModeColor", defaultValue: DefaultDarkModeColor)
    var darkModeColor: Color
}
