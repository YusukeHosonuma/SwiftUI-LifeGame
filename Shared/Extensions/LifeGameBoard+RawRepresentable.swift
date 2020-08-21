//
//  LifeGameBoard+RawRepresentable.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/21.
//

import Foundation
import LifeGame

// TODO: やっつけ実装かつ`generation`は保存できていないのであとで考える。
// なお、`RawValue`が`Data`だと`@AppStorage`の型宣言が`Data`になってしまうのでそこは考えもの。

extension LifeGameBoard: RawRepresentable {
    public init?(rawValue: String) {
        let cells = rawValue.compactMap { Int("\($0)") }.compactMap(Cell.init)
        let size = Int(sqrt(Double(cells.count)))
        self = LifeGameBoard(size: size, cells: cells)
    }
    
    public var rawValue: String {
        self.board.cells.map { "\($0.rawValue)" }.joined()
    }
}
