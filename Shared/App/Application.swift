//
//  LifeGameAppApp.swift
//  Shared
//
//  Created by Yusuke Hosonuma on 2020/07/15.
//

import SwiftUI
import Firebase

// TODO: プレビュー時でもインスタンス化されてるのでコスト
private let settingEnvironment: SettingEnvironment = .shared

@main
struct Application: App {
    @StateObject var viewModel = MainGameViewModel()

    init() {
        #if os(macOS)
        // TODO: How can disable scroll-bounce in mac?
        #elseif os(iOS)
        // ref: https://stackoverflow.com/a/59926791
        UIScrollView.appearance().bounces = false
        
        FirebaseApp.configure()
        #endif
    }
    
    var body: some Scene {
        #if os(macOS)
        windowGroup()
            .commands {
                LifeGameCommands(viewModel: viewModel)
            }
        #else
        windowGroup()
        #endif
        
        #if os(macOS)
        Settings {
            PreferenceView()
                .environmentObject(settingEnvironment)
        }
        #endif
    }
    
    @SceneBuilder
    func windowGroup() -> some Scene {
        WindowGroup {
            RootView(viewModel: viewModel)
                .environmentObject(settingEnvironment)
        }
    }
}
