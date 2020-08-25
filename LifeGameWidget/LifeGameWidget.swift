//
//  LifeGameWidget.swift
//  LifeGameWidget
//
//  Created by Yusuke Hosonuma on 2020/08/11.
//

import WidgetKit
import SwiftUI

@main
struct LifeGameWidget: Widget {
    let kind: String = "LifeGameWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: LifeGameConfigIntent.self, provider: Provider()) { entry in
            EntryView(entry: entry)
        }
        .configurationDisplayName("Random boards")
        .description("Enjoy random boards on Home screen.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
