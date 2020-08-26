//
//  Provider.swift
//  LifeGameWidgetExtension
//
//  Created by Yusuke Hosonuma on 2020/08/25.
//

import WidgetKit
import LifeGame
import Firebase
import FirebaseAuth

let exampleData = BoardExample.allCases.map { BoardData(title: $0.data.title, board: $0.data.board) }

struct Provider: IntentTimelineProvider {

    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), relevance: exampleData)
    }

    func getSnapshot(for configuration: LifeGameConfigIntent, in context: Context, completion: @escaping (Entry) -> ()) {
        completion(Entry(date: Date(), relevance: exampleData))
    }

    func getTimeline(for configuration: LifeGameConfigIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            
            // ref: https://firebase.google.com/docs/auth/ios/single-sign-on?hl=ja
            do {
                try Auth.auth().useUserAccessGroup("P437HSA6PY.shared")
            } catch let error as NSError {
                fatalError("Error changing user access group: \(error.localizedDescription)")
            }
        }
        
        let filteredByStared = Auth.auth().currentUser != nil && self.isFilteredByStared(configuration: configuration)

        let currentDate = Date()

        DataFetcher.shared.fetch { items in
            let entries: [Entry] = items
                .filter(when: filteredByStared) { $0.stared }
                .shuffled()
                .group(by: boardCount(family: context.family))
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
                    
                    return Entry(date: entryDate, relevance: data)
                }

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
    // MARK: Private
    
    private func boardCount(family: WidgetFamily) -> Int {
        switch family {
        case .systemSmall:  return 1
        case .systemMedium: return 4
        case .systemLarge:  return 1
        @unknown default:
            fatalError()
        }
    }
    
    private func isFilteredByStared(configuration: LifeGameConfigIntent) -> Bool {
        switch configuration.list {
        case .all:        return false
        case .staredOnly: return true
        default:
            return false
        }
    }
}
