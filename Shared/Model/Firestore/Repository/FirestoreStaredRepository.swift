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

final class FirestoreStaredRepository {
    let items: CurrentValueSubject<[StaredDocument], Never> = .init([])

    private let user: User
    
    private var stared: CollectionReference {
        return Firestore.firestore()
            .collection("users")
            .document(user.uid)
            .collection("stared")
    }
    
    init(user: User) {
        self.user = user
        stared
            .addSnapshotListener { (snapshot, error) in
                guard let snapshot = snapshot else { fatalError() }
                let documents = snapshot.documents.map(StaredDocument.init)
                self.items.value = documents
            }
    }
    
    func all() -> Future<[StaredDocument], Never> {
        Future { promise in
            self.stared
                .getDocuments { (snapshot, error) in
                    guard let snapshot = snapshot else { fatalError() }
                    let documents = snapshot.documents.map(StaredDocument.init)
                    promise(.success(documents))
                }
        }
    }
    
    // TODO: 削除したい
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
