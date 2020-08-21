//
//  AppLogger.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/16.
//

import os

enum AppLogger {
    static let imageLoadBug = Logger(subsystem: "LifeGameApp", category: "imageLoadBug")
    static let appLifecycle = Logger(subsystem: "LifeGameApp", category: "app.lifecycle")
}
