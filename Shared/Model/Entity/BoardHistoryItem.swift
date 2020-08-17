//
//  BoardHistoryItem.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/17.
//

import LifeGame

struct BoardHistoryItem: Identifiable {
    var id: String { historyID }
    var historyID: String
    var boardDocumentID: String
    var title: String
    var board: Board<Cell>
    var isStared: Bool
}
