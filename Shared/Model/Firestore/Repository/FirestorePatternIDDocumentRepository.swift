//
//  PatternIDDocumentRepository.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/12.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

final class PatternIDRepository {
    static let shared = PatternIDRepository()
    
    var all: Future<PatternIDDocument, Never> {
        Future { promise in
            Firestore.firestore()
                .collection("patternIds")
                .document("all3")
                .getDocument(completion: { (snapshot, error) in
                    if let error = error {
                        fatalError(error.localizedDescription)
                    }
                    let document = PatternIDDocument.init(snapshot: snapshot!)
                    promise(.success(document))
                })
        }
    }
}
