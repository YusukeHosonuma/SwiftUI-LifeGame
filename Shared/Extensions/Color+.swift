//
//  Color+.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/25.
//

import SwiftUI

extension Color: RawRepresentable {
    public var rawValue: Data {
        let color = UIColor(self)
        return try! NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
    }

    public init?(rawValue: Data) {
        guard let color = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(rawValue) as? UIColor else { return nil }
        self.init(color)
    }
}
