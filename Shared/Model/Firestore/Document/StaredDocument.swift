//
//  StaredDocument.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/17.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

// Keyed by BoardDocument.id
struct StaredDocument: Codable, PatternIdentifiable {
    @DocumentID
    var id: String!
    var reference: DocumentReference!
    
    var patternID: String
    
    init(patternID: String) {
        self.patternID = patternID
    }
    
    enum CodingKeys: CodingKey {
        case id
        case patternID
    }
}

extension StaredDocument {
    init(snapshot: DocumentSnapshot) {
        var document = try! snapshot.data(as: Self.self)
        document.reference = snapshot.reference
        self = document
    }
}
