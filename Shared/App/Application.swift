//
//  LifeGameAppApp.swift
//  Shared
//
//  Created by Yusuke Hosonuma on 2020/07/15.
//

import SwiftUI

private let settingEnvironment: SettingEnvironment = .shared

@main
struct Application: App {
    var body: some Scene {
        WindowGroup {
            RootView()
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
