//
//  UserDefaultSettingGroup.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/12.
//

import SwiftUI

private let Suite = "group.lifegame"

final public class UserDefaultSettingGroup {
    public static let shared = UserDefaultSettingGroup()

    public static let DefaultLightModeColor: Color = .black
    public static let DefaultDarkModeColor: Color = .white

    @UserDefaultGroup(suite: Suite,  key: "lightModeColor", defaultValue: DefaultLightModeColor)
    public var lightModeColor: Color

    @UserDefaultGroup(suite: Suite,  key: "darkModeColor", defaultValue: DefaultDarkModeColor)
    public var darkModeColor: Color
}
