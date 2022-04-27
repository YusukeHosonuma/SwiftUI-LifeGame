//
//  Entry.swift
//  LifeGameWidgetExtension
//
//  Created by Yusuke Hosonuma on 2020/08/25.
//

import WidgetKit
import LifeGame

struct Entry: TimelineEntry {
    var date: Date
    let relevance: [BoardData]
}

struct BoardData {
    var title: String
    var board: Board<Cell>
    var url: URL = URL(string: "board:///0")!
    var cacheKey: String?
}

extension BoardData {
    init(from item: PatternItem) {
        title = item.title
        board = item.board
        url = URL(string: "board:///\(item.patternID)")!
        cacheKey = item.id
    }
}
