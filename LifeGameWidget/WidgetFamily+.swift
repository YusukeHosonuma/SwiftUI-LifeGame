//
//  WidgetFamily+.swift
//  LifeGameWidgetExtension
//
//  Created by Yusuke Hosonuma on 2020/09/12.
//

import WidgetKit

extension WidgetFamily {
    var displayCount: Int {
        switch self {
        case .systemSmall:  return 1
        case .systemMedium: return 4
        case .systemLarge:  return 1
        @unknown default:
            fatalError()
        }
    }
}
