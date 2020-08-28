//
//  AppKitWrapper.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/28.
//

import AppKit

enum AppKitWrapper {
    
    // ref: https://heartbeat.fritz.ai/building-a-multi-platform-app-with-swiftui-5336bce94689
    static func toggleSidebar() {
        guard let object = NSApp.keyWindow?.firstResponder else { return }
        object.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}
