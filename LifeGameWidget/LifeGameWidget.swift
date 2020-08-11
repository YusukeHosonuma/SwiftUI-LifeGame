//
//  LifeGameWidget.swift
//  LifeGameWidget
//
//  Created by Yusuke Hosonuma on 2020/08/11.
//

import WidgetKit
import SwiftUI
import LifeGame

struct Provider: TimelineProvider {
    let preset = BoardPreset.nebura
    
    func placeholder(in context: Context) -> LifeGameEntry {
        return LifeGameEntry(date: Date(),
                             relevance: LifeGameData(title: preset.displayText, board: preset.board.board))
    }

    func getSnapshot(in context: Context, completion: @escaping (LifeGameEntry) -> ()) {
        let entry = LifeGameEntry(date: Date(),
                                  relevance: LifeGameData(title: preset.displayText, board: preset.board.board))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<LifeGameEntry>) -> ()) {
        var entries: [LifeGameEntry] = []

        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            
            // とりあえずランダムでチョイスするだけ
            let preset = BoardPreset.allCases.randomElement()!
            let data = LifeGameData(title: preset.displayText, board: preset.board.board.trimed(by: { $0 == .die}).extended(by: .die))
            let entry = LifeGameEntry(date: entryDate, relevance: data)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct LifeGameEntry: TimelineEntry {
    var date: Date
    let relevance: LifeGameData
}

struct LifeGameData {
    var title: String
    var board: Board<Cell>
}

struct LifeGameWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                BoardThumbnailImage(board: entry.relevance.board)
                Text(entry.relevance.title)
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
    }
}

@main
struct LifeGameWidget: Widget {
    let kind: String = "LifeGameWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LifeGameWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Random boards")
        .description("Enjoy random boards on Home screen.")
        .supportedFamilies([.systemSmall]) // とりあえず Small のみ
    }
}

struct LifeGameWidget_Previews: PreviewProvider {
    static let preset = BoardPreset.nebura
    static let entry = LifeGameEntry(date: Date(),
                                     relevance: LifeGameData(title: preset.displayText, board: preset.board.board))
    
    static var previews: some View {
        view(colorScheme: .light)
        view(colorScheme: .dark)
    }
    
    static func view(colorScheme: ColorScheme) -> some View {
        LifeGameWidgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            // Dark is not work in beta 4❗
            .colorScheme(colorScheme)
            .preferredColorScheme(colorScheme)
    }
}
