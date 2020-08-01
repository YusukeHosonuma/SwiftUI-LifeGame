//
//  UserDefaultConvertible.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/01.
//

import Foundation
import SwiftUI

protocol UserDefaultConvertible {
    init?(with object: Any)
    func object() -> Any
}

extension Int: UserDefaultConvertible {
    init?(with object: Any) {
        guard let value = object as? Int else { return nil }
        self = value
    }
    
    func object() -> Any {
        self
    }
}

extension Double: UserDefaultConvertible {
    init?(with object: Any) {
        guard let value = object as? Double else { return nil }
        self = value
    }
    
    func object() -> Any {
        self
    }
}

extension Color: UserDefaultConvertible {
    init?(with object: Any) {
        guard let data = object as? Data, let color = Color(rawValue: data) else { return nil }
        self = color
    }
    
    func object() -> Any {
        self.rawValue
    }
}
