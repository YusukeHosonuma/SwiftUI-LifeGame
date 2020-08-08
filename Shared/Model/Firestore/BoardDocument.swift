//
//  BoardDocument.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/06.
//

import FirebaseFirestoreSwift
import LifeGame

struct BoardDocument: Codable, Identifiable {
    @DocumentID
    var id: String?
    
    var title: String
    var size: Int
    var cells: [Int]
}

extension BoardDocument {
    init(id: String? = nil, title: String, board: LifeGameBoard) {
        self.id = id
        self.title = title
        size = board.size
        cells = board.cells.map(\.rawValue)
    }
    
    func makeBoard() -> LifeGameBoard {
        let board = Board(size: size, cells: cells.map { $0 == 0 ? Cell.die : Cell.alive })
        return LifeGameBoard(board: board)
    }
    
    // TODO: Firestore 側のデータをトリムする対応が終わったら不要になる
    func makeBoardForRender() -> LifeGameBoard {
        let board = Board(size: size, cells: cells.map { $0 == 0 ? Cell.die : Cell.alive })
            .trimed { $0 == .die }
            .extended(by: .die)
        return LifeGameBoard(board: board)
    }
}
