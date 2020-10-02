//
//  FirestorePatternRepository.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/11.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

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
            .limit(to: 40) // FIXME: 叩きすぎないように暫定処置 🏥
            .addSnapshotListener { (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error fetching snapshot results: \(error!)")
                    return
                }
                self.items = snapshot.documents.map(PatternDocument.init)
            }
    }

    func get(by reference: DocumentReference) -> Future<PatternDocument, Never> {
        Future { promise in
            reference.getDocument { (snapshot, error) in
                if let error = error {
                    fatalError(error.localizedDescription)
                }
                let document = PatternDocument(snapshot: snapshot!)
                promise(.success(document))
            }
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
            .limit(to: 40) // FIXME: 叩きすぎないように暫定処置 🏥
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
