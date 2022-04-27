//
//  FirestoreHistoryRepository.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/16.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirestoreHistoryRepository {
    let publisher: CurrentValueSubject<[HistoryDocument], Never> = .init([])

    private var listenerRegistration: ListenerRegistration?
    private var cancellables: [AnyCancellable] = []
    
    private func histories() -> CollectionReference {
        Firestore.firestore()
            .collection("users")
            .document(user.uid)
            .collection("histories")
    }
    
    private let user: User
    
    init(user: User) {
        self.user = user
        startListen()
    }
    
    deinit {
        stopListen()
    }
    
    func get(id: String, handler: @escaping (HistoryDocument?) -> Void) {
        histories()
            .document(id)
            .getDocument { (snapshot, error) in
                guard let snapshot = snapshot else { fatalError() }
                if snapshot.exists {
                    let document = HistoryDocument(snapshot: snapshot)
                    handler(document)
                } else {
                    handler(nil)
                }
            }
    }
    
    func setData(by patternID: String, document: HistoryDocument) {
        try! histories()
            .document(patternID)
            .setData(from: document)
    }

    // MARK: - Private
    
    private func startListen() {
        listenerRegistration = histories()
            .order(by: "updateAt", descending: true)
            .addSnapshotListener { (snapshot, error) in
                guard let snapshot = snapshot else { return }

                let documents = snapshot.documents.map(HistoryDocument.init)
                self.publisher.value = documents
            }
    }
    
    private func stopListen() {
        listenerRegistration?.remove()
    }
}
