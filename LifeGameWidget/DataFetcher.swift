//
//  DataFetcher.swift
//  LifeGameWidgetExtension
//
//  Created by Yusuke Hosonuma on 2020/08/18.
//

import Foundation
import LifeGame
import FirebaseAuth

// TODO: BoardStore と共通してる処理もあるので、Service として切り出すことを検討

final class DataFetcher {
    typealias Handler = ([BoardItem]) -> Void

    static let shared = DataFetcher()
    
    func fetch(handler: @escaping Handler) {
        if let user = Auth.auth().currentUser {
            fetchStaredBoards(staredRepository: FirestoreStaredRepository(user: user), handler)
        } else {
            fetchAllBoards(handler)
        }
    }
    
    // MARK: - Private
    
    private func fetchStaredBoards(staredRepository: FirestoreStaredRepository, _ handler: @escaping Handler) {
        staredRepository.getAll { documents in
            let staredIds = Set(documents.map(\.id))
            
            FirestoreBoardRepository.shared
                .getAll { documents in
                    let results = documents.map {
                        BoardItem(boardDocumentID: $0.id!,
                                  title: $0.title,
                                  board: $0.makeBoard(),
                                  stared: staredIds.contains($0.id!))
                    }
                    handler(results)
                }
        }
    }
    
    private func fetchAllBoards(_ handler: @escaping Handler) {
        FirestoreBoardRepository.shared
            .getAll { documents in
                let results = documents.map {
                    BoardItem(boardDocumentID: $0.id!,
                              title: $0.title,
                              board: $0.makeBoard(),
                              stared: false)
                }
                handler(results)
            }
    }
}
