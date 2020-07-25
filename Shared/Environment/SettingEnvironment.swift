//
//  SettingEnvironment.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/25.
//

import SwiftUI

final class SettingEnvironment: ObservableObject {
    @Published var darkModeColor: Color = .white
    @Published var lightModeColor: Color = .black
}
