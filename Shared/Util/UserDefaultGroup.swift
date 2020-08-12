//
//  UserDefaultGroup.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/12.
//

import Foundation

@propertyWrapper
struct UserDefaultGroup<T> where T: UserDefaultConvertible {
    let suite: String
    let key: String
    let defaultValue: T
    
    init(suite: String, key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
        self.suite = suite
    }
    
    var wrappedValue: T {
        get {
            guard let anyValue = UserDefaults(suiteName: suite)!.value(forKey: key) else { return defaultValue }
            guard let value = T(with: anyValue) else { return defaultValue }
            return value
        }
        set {
            UserDefaults(suiteName: suite)!.set(newValue.object(), forKey: key)
        }
    }
    
    func resetToDefault() {
        UserDefaults(suiteName: suite)!.set(defaultValue.object(), forKey: key)
    }
}
