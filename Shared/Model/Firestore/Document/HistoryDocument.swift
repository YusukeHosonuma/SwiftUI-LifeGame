//
//  HistoryDocument.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/16.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct HistoryDocument: Codable, PatternIdentifiable {
    
    @DocumentID
    var documentID: String!

    var reference: DocumentReference!

    @ServerTimestamp
    var updateAt: Date?

    var patternID: String { documentID }

    init() {}

    enum CodingKeys: CodingKey {
        case documentID
        case updateAt
    }
}

extension HistoryDocument {
    init(snapshot: DocumentSnapshot) {
        var document = try! snapshot.data(as: HistoryDocument.self)!
        document.reference = snapshot.reference
        self = document
    }
}
