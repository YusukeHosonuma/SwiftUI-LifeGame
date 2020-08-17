//
//  FirestoreStaredRepository.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/17.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

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

final class FirestoreStaredRepository {
    static var shared = FirestoreStaredRepository()
    
    let items: CurrentValueSubject<[StaredDocument], Never> = .init([])

    private var stared: CollectionReference {
        guard let uid = Auth.auth().currentUser?.uid else { fatalError() }
        
        return Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("stared")
    }
    
    init() {
        stared
            .addSnapshotListener { (snapshot, error) in
                guard let snapshot = snapshot else { fatalError() }
                let documents = snapshot.documents.map(StaredDocument.init)
                self.items.value = documents
            }
    }
    
    func getAll(handler: @escaping ([StaredDocument]) -> Void) {
        stared
            .getDocuments { (snapshot, error) in
                guard let snapshot = snapshot else { fatalError() }
                let documents = snapshot.documents.map(StaredDocument.init)
                handler(documents)
            }
    }
    
    func get(id: String, handler: @escaping (StaredDocument?) -> Void) {
        stared
            .document(id)
            .getDocument { (snapshot, error) in
                guard let snapshot = snapshot else { fatalError() }
                if snapshot.exists {
                    let document = StaredDocument(snapshot: snapshot)
                    handler(document)
                } else {
                    handler(nil)
                }
            }
    }
    
    func add(id: String, document: StaredDocument) {
        try! stared
            .document(id)
            .setData(from: document)
    }
    
    func delete(id: String) {
        stared
            .document(id)
            .delete()
    }
}
