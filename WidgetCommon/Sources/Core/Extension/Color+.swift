//
//  Color+.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/25.
//

import SwiftUI

public extension Color {
    static var placeholderText: Color {
        #if os(macOS)
        return Color(NSColor.placeholderTextColor)
        #else
        return Color(UIColor.placeholderText)
        #endif
    }
    
    // Note:
    // beta 5 から標準で`cgColor`プロパティが用意されたが、返却値がOptional型になっており、
    // 固定値の`Color`でも変換できないことがあったので、解決されるまでは現状のextensionを残す。（beta 6）❗
    func toCGColor() -> CGColor {
        #if os(macOS)
        return NSColor(self).cgColor
        #else
        return UIColor(self).cgColor
        #endif
    }
}

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
