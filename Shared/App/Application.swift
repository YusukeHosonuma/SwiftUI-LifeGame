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
    @StateObject var viewModel = MainGameViewModel()

    var body: some Scene {
        WindowGroup {
            RootView(viewModel: viewModel)
                .environmentObject(settingEnvironment)
        }
        .commands {
            LifeGameCommands(viewModel: viewModel)
        }
        
        #if os(macOS)
        Settings {
            PreferenceView()
                .environmentObject(settingEnvironment)
        }
        #endif
    }
}
