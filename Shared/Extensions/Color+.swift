//
//  Color+.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/25.
//

import SwiftUI

extension Color: RawRepresentable {
    public var rawValue: Data {
        #if os(macOS)
        let color = NSColor(self)
        #else
        let color = UIColor(self)
        #endif
        return try! NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
    }

    public init?(rawValue: Data) {
        guard let data = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(rawValue) else { return nil }
        #if os(macOS)
        guard let color = data as? NSColor else { return nil }
        #else
        guard let color = data as? UIColor else { return nil }
        #endif
        self.init(color)
    }
}
