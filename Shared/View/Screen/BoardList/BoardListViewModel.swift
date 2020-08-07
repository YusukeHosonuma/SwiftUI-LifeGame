//
//  BoardListViewModel.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/06.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class BoardListViewModel: ObservableObject {
    @Published var items: [BoardDocument] = []
    
    init() {
        Firestore.firestore()
            .collection("boards")
            .addSnapshotListener { (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error fetching snapshot results: \(error!)")
                    return
                }

                let documents = snapshot.documents.map { document in
                    try! document.data(as: BoardDocument.self)!
                }

                self.items = documents
            }
    }
}
