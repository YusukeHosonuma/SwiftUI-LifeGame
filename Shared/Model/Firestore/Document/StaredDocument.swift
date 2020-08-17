//
//  StaredDocument.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/17.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

// Keyed by BoardDocument.id
struct StaredDocument: Codable {
    @DocumentID var id: String!
    var reference: DocumentReference!
    var referenceBoard: DocumentReference
    
    init(referenceBoard: DocumentReference) {
        self.referenceBoard = referenceBoard
    }
    
    init(snapshot: DocumentSnapshot) {
        var document = try! snapshot.data(as: Self.self)!
        document.reference = snapshot.reference
        self = document
    }
}
