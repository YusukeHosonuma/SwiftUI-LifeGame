//
//  FirestoreFeedbackRepository.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirestoreFeedbackRepository {
    static let shared = FirestoreFeedbackRepository()
    
    private init() {}
    
    func add(_ document: FeedbackDocument) {
        do {
            _ = try Firestore.firestore()
                .collection("feedbacks")
                .addDocument(from: document)
        } catch {
            fatalError("Encode is failure. \(error.localizedDescription)")
        }
    }
}
