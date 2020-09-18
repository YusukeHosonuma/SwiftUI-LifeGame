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
    
    @ServerTimestamp
    var createdAt: Date?
    
    var patternDocumentRef: DocumentReference

    // MARK: Resolved after decoded
    var reference: DocumentReference!
    var board: PatternDocument!

    var patternID: String { documentID }
    
    enum CodingKeys: CodingKey {
        case documentID
        case patternDocumentRef
        case createdAt
    }
    
    init(patternDocumentRef: DocumentReference) {
        self.patternDocumentRef = patternDocumentRef
    }
}

extension HistoryDocument {
    init(snapshot: DocumentSnapshot) {
        var document = try! snapshot.data(as: HistoryDocument.self)!
        document.reference = snapshot.reference
        self = document
    }
}
