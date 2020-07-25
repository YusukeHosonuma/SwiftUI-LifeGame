//
//  LifeGameAppApp.swift
//  Shared
//
//  Created by Yusuke Hosonuma on 2020/07/15.
//

import SwiftUI

private let settingEnvironment = SettingEnvironment()

@main
struct LifeGameApplication: App {
    var body: some Scene {
        WindowGroup {
            ContainerView()
                .environmentObject(settingEnvironment)
        }
        #if os(macOS)
        Settings {
            PreferenceView()
                .environmentObject(settingEnvironment)
        }
        #endif
    }
}
