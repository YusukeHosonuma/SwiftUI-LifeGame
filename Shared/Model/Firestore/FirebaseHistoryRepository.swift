//
//  FirebaseHistoryRepository.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/16.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirebaseHistoryRepository: ObservableObject {
    static let shared = FirebaseHistoryRepository() // 暫定
    
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
    
    // TODO: refactor - Repository 以上のことをしているのでそのうち Service を抽出する
    
    func moveToFirst(id: String) {
        histories()
            .document(id)
            .updateData(["createdAt" : FieldValue.serverTimestamp()])
    }
    
    func add(_ document: HistoryDocument) {
        histories()
            .whereField("boardReference", isEqualTo: document.boardReference)
            .getDocuments { (snapshot, error) in
                guard let snapshot = snapshot else { fatalError() }

                let documents = snapshot.documents.map(HistoryDocument.init)
                
                if let document = documents.first {
                    self.moveToFirst(id: document.id)
                } else {
                    _ = try! self.histories().addDocument(from: document)
                }
            }
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
