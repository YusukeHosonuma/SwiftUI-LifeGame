//
//  BoardExample.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/25.
//

import LifeGame

// Note:
// Widgetのプレースホルダなど、固定時間での表示が望ましいケースで表示例として利用すること。
// （Widget専用にしちゃってもよいかも？）

enum BoardExample: CaseIterable {
    struct Data {
        var title: String
        var board: Board<Cell>
    }
    
    case butterfly
    case cross
    case monolith
    case nebura
    
    var data: Data {
        switch self {
        case .butterfly:
            return Data(
                title: "Butterfly",
                board: Board(size: 4, cells: cells([1,0,0,0,1,1,0,0,1,0,1,0,0,1,1,1]))
            )
        case .cross:
            return Data(
                title: "Cross",
                board: Board(size: 8, cells: cells([0,0,1,1,1,1,0,0,0,0,1,0,0,1,0,0,1,1,1,0,0,1,1,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,0,0,1,0,0,1,0,0,0,0,1,1,1,1,0,0]))
            )
        case .monolith:
            return Data(
                title: "Monolith",
                board: Board(size: 11, cells: cells([1,1,0,1,1,0,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,0,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,0,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,0,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1]))
            )
        case .nebura:
            return Data(
                title: "Nebura",
                board: Board(size: 9, cells: cells([1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1]))
            )
        }
    }
    
    private func cells(_ rawCells: [Int]) -> [Cell] {
        rawCells.map { $0 == 1 ? Cell.alive : Cell.die }
    }
}
