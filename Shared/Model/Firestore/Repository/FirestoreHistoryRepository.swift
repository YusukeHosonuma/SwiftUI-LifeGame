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
    static let shared = FirestoreHistoryRepository() // 暫定
    
    @Published var items: [HistoryDocument] = []

    private let authentication: Authentication
    
    private var listenerRegistration: ListenerRegistration?
    private var cancellables: [AnyCancellable] = []
    
    init(authentication: Authentication = .shared) {
        self.authentication = authentication
        self.authentication.$isSignIn
            .sink { [unowned self] isSignIn in
                if isSignIn {
                    self.startListen()
                } else {
                    self.stopListen()
                }
            }
            .store(in: &cancellables)
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
    
    private func histories() -> CollectionReference {
        guard let uid = Auth.auth().currentUser?.uid else { fatalError() }

        return Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("histories")
    }
    
    private func startListen() {
        let dispatchGroup = DispatchGroup()

        listenerRegistration = histories()
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { (snapshot, error) in
                guard let snapshot = snapshot else { fatalError() }

                var documents = snapshot.documents.map(HistoryDocument.init)
                
                for (index, document) in documents.enumerated() {
                    dispatchGroup.enter() // ▶️
                    
                    document.boardReference.getDocument { (snapshot, error) in
                        guard let snapshot = snapshot else { fatalError() }

                        var newDocument = document
                        newDocument.board = BoardDocument(snapshot: snapshot)
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
