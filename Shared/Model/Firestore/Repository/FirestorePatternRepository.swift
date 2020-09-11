//
//  FirestorePatternRepository.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/11.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol FirestorePatternRepositoryProtorol: ObservableObject  {
    var items: [PatternDocument] { get }
    
    func add(_ document: PatternDocument)
    func get(by id :String, handler: @escaping (PatternDocument) -> Void)
    func getAll(handler: @escaping ([PatternDocument]) -> Void) // TODO: そのうち Combine にする
    func update(_ document: PatternDocument)
}

final class FirestorePatternRepository: ObservableObject {
    static let shared = FirestorePatternRepository()

    @Published var items: [PatternDocument] = []
    
    private var collection: CollectionReference {
        Firestore.firestore().collection("patterns")
    }
    
    private init() {
        collection
            .order(by: "title")
            .addSnapshotListener { (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error fetching snapshot results: \(error!)")
                    return
                }
                self.items = snapshot.documents.map(PatternDocument.init)
            }
    }

    func get(by id :String, handler: @escaping (PatternDocument) -> Void) {
        collection
            .document(id)
            .getDocument { (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error fetching snapshot results: \(error!)")
                    return
                }
                
                let document = PatternDocument(snapshot: snapshot)
                handler(document)
            }
    }

    func getAll(handler: @escaping ([PatternDocument]) -> Void) {
        collection
            .order(by: "title")
            .getDocuments  { (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error fetching snapshot results: \(error!)")
                    return
                }

                let documents = snapshot.documents.map(PatternDocument.init)
                handler(documents)
            }
    }
}
