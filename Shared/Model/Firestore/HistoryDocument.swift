//
//  HistoryDocument.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/16.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct HistoryDocument: Codable {
    @DocumentID      var id: String!
    @ServerTimestamp var createdAt: Date?
    var boardReference: DocumentReference

    // MARK: Resolved after decoded
    var reference: DocumentReference!
    var board: BoardDocument!

    enum CodingKeys: CodingKey {
        case id
        case boardReference
        case createdAt
    }
    
    init(boardReference: DocumentReference) {
        self.boardReference = boardReference
    }
    
    init(snapshot: DocumentSnapshot) {
        var document = try! snapshot.data(as: HistoryDocument.self)!
        document.reference = snapshot.reference
        self = document
    }
}
