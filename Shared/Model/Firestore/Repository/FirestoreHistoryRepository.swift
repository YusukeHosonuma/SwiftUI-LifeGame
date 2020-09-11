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

final class FirestoreHistoryRepository: ObservableObject {
    @Published var items: [HistoryDocument] = []
    
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
    
    func add(by boardID: String, _ document: HistoryDocument) {
        try! histories()
            .document(boardID)
            .setData(from: document)
    }
    
    // TODO: refactor - Repository 以上のことをしているのでそのうち Service を抽出する

    func moveToFirst(id: String) {
        histories()
            .document(id)
            .updateData(["createdAt" : FieldValue.serverTimestamp()])
    }

    
    // MARK: - Private

    
    private func startListen() {
        let dispatchGroup = DispatchGroup()

        listenerRegistration = histories()
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { (snapshot, error) in
                guard let snapshot = snapshot else { fatalError() }

                var documents = snapshot.documents.map(HistoryDocument.init)
                
                for (index, document) in documents.enumerated() {
                    dispatchGroup.enter() // ▶️
                    
                    document.patternDocumentRef.getDocument { (snapshot, error) in
                        guard let snapshot = snapshot else { fatalError() }

                        var newDocument = document
                        newDocument.board = PatternDocument(snapshot: snapshot)
                        documents[index] = newDocument
                        
                        dispatchGroup.leave() // ↩️
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    self.items = documents
                }
            }
    }
    
    private func stopListen() {
        listenerRegistration?.remove()
    }
}
