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

    init() {
        // ref: https://stackoverflow.com/a/59926791
        #if os(iOS)
        UIScrollView.appearance().bounces = false // FIXME: ✅ Support macOS
        #endif
    }
    
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
