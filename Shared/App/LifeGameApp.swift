//
//  LifeGameAppApp.swift
//  Shared
//
//  Created by Yusuke Hosonuma on 2020/07/15.
//

import SwiftUI

@main
struct LifeGameApplication: App {
    var body: some Scene {
        WindowGroup {
            ContainerView()
                .environmentObject(SettingEnvironment())
        }
    }
}
