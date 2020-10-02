//
//  BoardItem.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/17.
//

import SwiftUI
import LifeGame

struct PatternItem: Equatable, Identifiable {
    var patternID: String
    var title: String
    var board: Board<Cell>
    var stared: Bool

    var id: String { patternID }
}
