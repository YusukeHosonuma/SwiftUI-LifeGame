//
//  PatternIndexRepository.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/12.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

final class FirestorePatternIndexRepository {
    static let shared = FirestorePatternIndexRepository()
    
    var all: Future<PatternIndexDocument, Never> {
        Future { promise in
            Firestore.firestore()
                .collection("patternIndex")
                .document("All")
                .getDocument { (snapshot, error) in
                    if let error = error {
                        fatalError(error.localizedDescription)
                    }
                    let document = PatternIndexDocument.init(snapshot: snapshot!)
                    promise(.success(document))
                }
        }
    }
}
