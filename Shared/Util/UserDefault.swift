//
//  UserDefault.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/01.
//

import Foundation
import Core

@propertyWrapper
struct UserDefault<T> where T: UserDefaultConvertible {
    let key: String
    let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            guard let anyValue = UserDefaults.standard.object(forKey: key) else {
                AppLogger.imageLoadBug.notice("[UserDefault] Read faled... (not found). (key: \(key, privacy: .public))")
                return defaultValue
            }
            guard let value = T(with: anyValue) else {
                AppLogger.imageLoadBug.error("[UserDefault] Read faled... (decode is failed). (key: \(key, privacy: .public))")
                return defaultValue
            }
            AppLogger.imageLoadBug.notice("[UserDefault] Read. (key: \(key, privacy: .public))")
            return value
        }
        set {
            let localKey = key
            if let value = newValue.object() {
                AppLogger.imageLoadBug.notice("[UserDefault] Write. (key: \(localKey, privacy: .public))")
                UserDefaults.standard.set(value, forKey: key)
            } else {
                AppLogger.imageLoadBug.notice("[UserDefault] Remove. (key: \(localKey, privacy: .public))")
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
    
    func resetToDefault() {
        UserDefaults.standard.set(defaultValue.object(), forKey: key)
    }
}
