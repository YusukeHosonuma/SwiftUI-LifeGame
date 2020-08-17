//
//  BoardDocument.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/06.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import LifeGame

struct BoardDocument: Codable, Identifiable {
    @DocumentID
    var id: String?
    var reference: DocumentReference!
    
    var title: String
    var size: Int
    var cells: [Int]
    var stared: Bool // TODO: あとで消す
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case size
        case cells
        case stared
    }
    
    init(snapshot: DocumentSnapshot) {
        var document = try! snapshot.data(as: Self.self)!
        document.reference = snapshot.reference
        self = document
    }
}

extension BoardDocument: Equatable {
    static func == (lhs: BoardDocument, rhs: BoardDocument) -> Bool {
        lhs.id! == rhs.id!
    }
}

extension BoardDocument {
    init(id: String? = nil, title: String, board: LifeGameBoard) {
        self.id = id
        self.title = title
        size = board.size
        cells = board.cells.map(\.rawValue)
        stared = false
    }
    
    func makeBoard() -> Board<Cell> {
        Board(size: size, cells: cells.map { $0 == 0 ? Cell.die : Cell.alive })
    }
}
