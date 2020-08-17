//
//  BoardItem.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/17.
//

import SwiftUI
import LifeGame

struct BoardItem: Equatable, Identifiable {
    var id: String { boardDocumentID }
    var boardDocumentID: String
    var title: String
    var board: Board<Cell>
    var stared: Bool
}
