//
//  UserDefault.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/01.
//

import Foundation

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
            guard let anyValue = UserDefaults.standard.value(forKey: key) else { return defaultValue }
            guard let value = T(with: anyValue) else { return defaultValue }
            return value
        }
        set {
            if let value = newValue.object() {
                UserDefaults.standard.set(value, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
    
    func resetToDefault() {
        UserDefaults.standard.set(defaultValue.object(), forKey: key)
    }
}
