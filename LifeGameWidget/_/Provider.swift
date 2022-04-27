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
        
        let staredOnly = self.isFilteredByStared(configuration: configuration)

        TimelineEntryGenerator.shared.generate(for: context.family, times: 5, staredOnly: staredOnly) { entries in
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
    // MARK: Private
    
    private func isFilteredByStared(configuration: LifeGameConfigIntent) -> Bool {
        switch configuration.list {
        case .all:        return false
        case .staredOnly: return true
        default:
            return false
        }
    }
}
