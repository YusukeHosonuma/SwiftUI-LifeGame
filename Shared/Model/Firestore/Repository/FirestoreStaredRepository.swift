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
    let publisher: CurrentValueSubject<[StaredDocument], Never> = .init([])

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
                self.publisher.value = documents
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
    
    func get(by id: String) -> Future<StaredDocument?, Never> {
        Future { promise in
            self.stared
                .document(id)
                .getDocument { (snapshot, error) in
                    if let error = error {
                        fatalError(error.localizedDescription)
                    }
                    if snapshot!.exists {
                        let document = StaredDocument(snapshot: snapshot!)
                        promise(.success(document))
                    } else {
                        promise(.success(nil))
                    }
                }
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
    
    func setData(_ document: StaredDocument) {
        try! stared
            .document(document.patternID)
            .setData(from: document)
    }
    
    func delete(by id: String) {
        stared
            .document(id)
            .delete()
    }
}
