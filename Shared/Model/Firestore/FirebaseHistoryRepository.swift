//
//  FirebaseHistoryRepository.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/16.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirebaseHistoryRepository: ObservableObject {
    static let shared = FirebaseHistoryRepository() // 暫定
    
    @Published var items: [HistoryDocument] = []
  
    private let dispatchGroup = DispatchGroup()
    
    init() {
        // TODO: あとでアカウントに紐付けて管理するようにする
        
        Firestore.firestore()
            .collection("histories")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { (snapshot, error) in
                guard let snapshot = snapshot else { fatalError() }

                var documents: [HistoryDocument] = snapshot.documents.map {
                    try! $0.data(as: HistoryDocument.self)!
                }
                
                for (index, document) in documents.enumerated() {
                    self.dispatchGroup.enter() // ▶️
                    
                    document.boardReference.getDocument { (snapshot, error) in
                        guard let snapshot = snapshot else { fatalError() }

                        var newDocument = document
                        newDocument.board = BoardDocument(snapshot: snapshot)
                        documents[index] = newDocument
                        
                        self.dispatchGroup.leave() // ↩️
                    }
                }
                
                self.dispatchGroup.notify(queue: .main) {
                    self.items = documents
                }
            }
    }
    
    // TODO: refactor - Repository 以上のことをしているのでそのうち Service を抽出する
    
    func add(_ document: HistoryDocument) {
        Firestore.firestore()
            .collection("histories")
            .getDocuments { (snapshot, error) in
                guard let snapshot = snapshot else { fatalError() }

                let documents = snapshot.documents
                    .map(HistoryDocument.init)
                
                if let exists = documents.first(where: { $0.boardReference == document.boardReference }) {
                    self.delete(by: exists.id!)
                }
                                
                _ = try! Firestore.firestore()
                    .collection("histories")
                    .addDocument(from: document)
            }
    }
    
    func delete(by id: String) {
        Firestore.firestore()
            .collection("histories")
            .document(id)
            .delete()
    }
}
