//
//  LifeGameMacWidget.swift
//  LifeGameMacWidget
//
//  Created by 細沼祐介 on 2022/04/27.
//

import WidgetKit
import SwiftUI
import WidgetCommon

@main
struct LifeGameWidget: Widget {
    let kind: String = "LifeGameWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: LifeGameConfigIntent.self, provider: Provider()) { entry in
            EntryView(entry: entry)
        }
        .configurationDisplayName("Random boards")
        .description("Enjoy random boards on Home screen.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
