//
//  LifeGameWidget.swift
//  LifeGameWidget
//
//  Created by Yusuke Hosonuma on 2020/08/11.
//

import WidgetKit
import SwiftUI
import LifeGame
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> LifeGameEntry {
        let data = BoardExample.allCases.map { BoardData(title: $0.data.title, board: $0.data.board) }
        return LifeGameEntry(date: Date(), relevance: LifeGameData(boards: data))
    }

    func getSnapshot(for configuration: LifeGameConfigIntent, in context: Context, completion: @escaping (LifeGameEntry) -> ()) {
        let data = BoardExample.allCases.map { BoardData(title: $0.data.title, board: $0.data.board) }
        let entry = LifeGameEntry(date: Date(), relevance: LifeGameData(boards: data))
        completion(entry)
    }

    func getTimeline(for configuration: LifeGameConfigIntent, in context: Context, completion: @escaping (Timeline<LifeGameEntry>) -> ()) {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            
            // ref: https://firebase.google.com/docs/auth/ios/single-sign-on?hl=ja
            do {
                try Auth.auth().useUserAccessGroup("P437HSA6PY.shared")
            } catch let error as NSError {
                fatalError("Error changing user access group: \(error.localizedDescription)")
            }
        }
        
        let isFilteredByStared: Bool
        
        switch configuration.list {
        case .all:        isFilteredByStared = false
        case .staredOnly: isFilteredByStared = true
        default:          isFilteredByStared = false
        }

        let currentDate = Date()

        WidgetDataFetcher.shared.fetch { items in
            let entries: [LifeGameEntry] = items
                .filter(when: Auth.auth().currentUser != nil && isFilteredByStared) { $0.stared }
                .shuffled()
                .group(by: 4)
                .prefix(5)
                .enumerated()
                .map { hourOffset, documents in
                    let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
                    
                    let data = documents.map { document in
                        BoardData(title: document.title,
                                  board: document.board,
                                  url: URL(string: "board:///\(document.id)")!,
                                  cacheKey: document.id)
                    }
                    
                    return LifeGameEntry(date: entryDate, relevance: LifeGameData(boards: data))
                }

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct LifeGameEntry: TimelineEntry {
    var date: Date
    let relevance: LifeGameData
}

struct LifeGameData {
    var boards: [BoardData]
}

struct BoardData {
    var title: String
    var board: Board<Cell>
    var url: URL = URL(string: "board:///0")!
    var cacheKey: String?
}

struct LifeGameWidgetEntryView : View {
    @Environment(\.widgetFamily) private var widgetFamily
    @Environment(\.colorScheme) private var colorScheme
    
    var entry: Provider.Entry

    var body: some View {
        if widgetFamily == .systemSmall {
            HStack {
                boardView(data: entry.relevance.boards.first!)
                Spacer()
            }
            .padding()
            .widgetURL(entry.relevance.boards.first!.url)
        } else {
            HStack {
                ForEach(entry.relevance.boards, id: \.title) { data in
                    Link(destination: data.url) {
                        boardView(data: data)
                    }
                }
            }
            .padding()
        }
    }
    
    func boardView(data: BoardData) -> some View {
        VStack(alignment: .leading) {
            BoardThumbnailImage(board: data.board, cellColor: cellColor, cacheKey: data.cacheKey)
            Text(data.title)
                .font(.system(.caption2, design: .monospaced))
                .foregroundColor(.gray)
                .lineLimit(1)
        }
    }
    
    var cellColor: Color {
        switch colorScheme {
        case .light: return UserDefaultSettingGroup.shared.lightModeColor
        case .dark:  return UserDefaultSettingGroup.shared.darkModeColor
        @unknown default:
            fatalError()
        }
    }
}

@main
struct LifeGameWidget: Widget {
    let kind: String = "LifeGameWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: LifeGameConfigIntent.self, provider: Provider()) { entry in
            LifeGameWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Random boards")
        .description("Enjoy random boards on Home screen.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct LifeGameWidget_Previews: PreviewProvider {
    static let preset = BoardPreset.nebura
    static let entry = LifeGameEntry(date: Date(),
                                     relevance: LifeGameData(boards: [BoardData(title: preset.displayText, board: preset.board.board)]))
    
    static var previews: some View {
        view(colorScheme: .light)
        view(colorScheme: .dark)
    }
    
    static func view(colorScheme: ColorScheme) -> some View {
        LifeGameWidgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            // Dark is not work in beta4❗
            .colorScheme(colorScheme)
            .preferredColorScheme(colorScheme)
    }
}
