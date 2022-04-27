//
//  Entry.swift
//  LifeGameWidgetExtension
//
//  Created by Yusuke Hosonuma on 2020/08/25.
//

import WidgetKit
import LifeGame
import Core

public struct Entry: TimelineEntry {
    public var date: Date
    public let relevance: [BoardData]

    public init(date: Date, relevance: [BoardData]) {
        self.date = date
        self.relevance = relevance
    }
}

public struct BoardData {
    public var title: String
    public var board: Board<Cell>
    public var url: URL = URL(string: "board:///0")!
    public var cacheKey: String?

    public init(
        title: String,
        board: Board<Cell>,
        url: URL = URL(string: "board:///0")!,
        cacheKey: String? = nil
    ) {
        self.title = title
        self.board = board
        self.url = url
        self.cacheKey = cacheKey
    }
}

public extension BoardData {
    init(from item: PatternItem) {
        title = item.title
        board = item.board
        url = URL(string: "board:///\(item.patternID)")!
        cacheKey = item.id
    }
}
