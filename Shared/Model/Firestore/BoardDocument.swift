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
}
