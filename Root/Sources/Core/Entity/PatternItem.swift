//
//  BoardItem.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/17.
//

import SwiftUI
import LifeGame

public struct PatternItem: Equatable, Identifiable {
    public var patternID: String
    public var title: String
    public var board: Board<Cell>
    public var stared: Bool

    public var id: String { patternID }
    
    public init(patternID: String, title: String, board: Board<Cell>, stared: Bool) {
        self.patternID = patternID
        self.title = title
        self.board = board
        self.stared = stared
    }
}
