//
//  UserDefaultConvertible.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/01.
//

import Foundation
import SwiftUI

public protocol UserDefaultConvertible {
    init?(with object: Any)
    func object() -> Any?
}

extension Bool: UserDefaultConvertible {
    public init?(with object: Any) {
        guard let value = object as? Bool else { return nil }
        self = value
    }
    
    public func object() -> Any? {
        self
    }
}

extension Int: UserDefaultConvertible {
    public init?(with object: Any) {
        guard let value = object as? Int else { return nil }
        self = value
    }
    
    public func object() -> Any? {
        self
    }
}

extension Double: UserDefaultConvertible {
    public init?(with object: Any) {
        guard let value = object as? Double else { return nil }
        self = value
    }
    
    public func object() -> Any? {
        self
    }
}

extension Color: UserDefaultConvertible {
    public init?(with object: Any) {
        guard let data = object as? Data, let color = Color(rawValue: data) else { return nil }
        self = color
    }
    
    public func object() -> Any? {
        self.rawValue
    }
}
