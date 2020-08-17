//
//  FirestoreBoardRepository.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/06.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol FirestoreBoardRepositoryProtorol: ObservableObject  {
    var items: [BoardDocument] { get }
    
    func add(_ document: BoardDocument)
    func get(by id :String, handler: @escaping (BoardDocument) -> Void)
    func getAll(handler: @escaping ([BoardDocument]) -> Void) // TODO: そのうち Combine にする
    func update(_ document: BoardDocument)
}

final class FirestoreBoardRepository: ObservableObject, FirestoreBoardRepositoryProtorol {
    static var shared = FirestoreBoardRepository()
    
    @Published var items: [BoardDocument] = []
    
    private var collection: CollectionReference {
        Firestore.firestore().collection("presets2")
    }
    
    private init() {
        collection
            .order(by: "title")
            .addSnapshotListener { (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error fetching snapshot results: \(error!)")
                    return
                }

                self.items = snapshot.documents.map(BoardDocument.init)
            }
    }
    
    func add(_ document: BoardDocument) {
        _ = try! collection
            .addDocument(from: document)
    }
    
    func get(by id :String, handler: @escaping (BoardDocument) -> Void) {
        collection
            .document(id)
            .getDocument { (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error fetching snapshot results: \(error!)")
                    return
                }
                
                let document = BoardDocument(snapshot: snapshot)
                handler(document)
            }
    }

    func getAll(handler: @escaping ([BoardDocument]) -> Void) {
        collection
            .order(by: "title")
            .getDocuments  { (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error fetching snapshot results: \(error!)")
                    return
                }

                let documents = snapshot.documents.map(BoardDocument.init)
                handler(documents)
            }
    }
    
    func update(_ document: BoardDocument) {
        try! collection
            .document(document.id!)
            .setData(from: document)
    }
}
