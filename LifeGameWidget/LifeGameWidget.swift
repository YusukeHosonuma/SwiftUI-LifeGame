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
        let data = LifeGameData(title: "Title", board: Board(size: 12, cell: Cell.die))
        return LifeGameEntry(date: Date(), relevance: data)
    }

    func getSnapshot(for configuration: LifeGameConfigIntent, in context: Context, completion: @escaping (LifeGameEntry) -> ()) {
        let preset = BoardPreset.nebura
        let data = LifeGameData(title: preset.displayText, board: preset.board.board)
        let entry = LifeGameEntry(date: Date(), relevance: data)
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
                .prefix(5) // TODO: とりあえず5つだけ（デバッグしやすさも兼ねて）
                .enumerated()
                .map { hourOffset, document in
                    let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
                    let data = LifeGameData(title: document.title,
                                            board: document.board.extended(by: .die),
                                            url: URL(string: "board:///\(document.id)")!,
                                            cacheKey: document.id)
                    return LifeGameEntry(date: entryDate, relevance: data)
                }

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
        
//        FirestoreBoardRepository.shared
//            .getAll { documents in
//                //let currentDate = Date()
//
//                let entries: [LifeGameEntry] = documents
//                    .filter(when: isFilteredByStared) { $0.stared } // 大した件数でも無いので Firestore でなくロジックでフィルターしてしまう
//                    .shuffled()
//                    .prefix(5) // TODO: とりあえず5つだけ（デバッグしやすさも兼ねて）
//                    .enumerated()
//                    .map { hourOffset, document in
//                        let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
//                        let data = LifeGameData(title: document.title,
//                                                board: document.makeBoard().extended(by: .die),
//                                                url: URL(string: "board:///\(document.id!)")!,
//                                                cacheKey: document.id!)
//                        return LifeGameEntry(date: entryDate, relevance: data)
//                    }
//
//                let timeline = Timeline(entries: entries, policy: .atEnd)
//                completion(timeline)
//            }
    }
}

struct LifeGameEntry: TimelineEntry {
    var date: Date
    let relevance: LifeGameData
}

struct LifeGameData {
    var title: String
    var board: Board<Cell>
    var url: URL = URL(string: "board:///0")!
    var cacheKey: String?
}

struct LifeGameWidgetEntryView : View {
    @Environment(\.colorScheme) private var colorScheme
    
    var entry: Provider.Entry

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                BoardThumbnailImage(board: entry.relevance.board, cellColor: cellColor, cacheKey: entry.relevance.cacheKey)
                Text(entry.relevance.title)
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundColor(.gray)
            }
            .widgetURL(entry.relevance.url)
            Spacer()
        }
        .padding()
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
            // Dark is not work in beta4❗
            .colorScheme(colorScheme)
            .preferredColorScheme(colorScheme)
    }
}
