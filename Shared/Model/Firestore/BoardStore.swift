//
//  BoardStore.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/17.
//

import Foundation
import SwiftUI
import Combine
import LifeGame
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

protocol BoardStoreProtocol: ObservableObject {
    var allBoards: [BoardItem] { get }
    var histories: [BoardHistoryItem] { get }
    
    func toggleLike(boardID: String)
    func addToHistory(boardID: String, user: User)
}

final class BoardStore: BoardStoreProtocol {
    static var shared = BoardStore()
    
    @Published var allBoards: [BoardItem] = []
    @Published var histories: [BoardHistoryItem] = []
    
    private let boardRepository: FirestoreBoardRepository = .shared
    private let staredRepository: FirestoreStaredRepository = .shared
    private let historyRepository: FirebaseHistoryRepository = .shared
    
    private var cancellables: [AnyCancellable] = []
    
    init() {
        let staredIdsPublisher = staredRepository.items.map { Set($0.map(\.id)) }
        
        boardRepository.$items.combineLatest(staredIdsPublisher)
            .map { boards, staredIds in
                boards.map {
                    BoardItem(boardDocumentID: $0.id!,
                              title: $0.title,
                              board: $0.makeBoard(),
                              stared: staredIds.contains($0.id!))
                }
            }
            .assign(to: &$allBoards)
        
        historyRepository.$items.combineLatest(staredIdsPublisher)
            .map { histories, staredIds in
                histories.map {
                    BoardHistoryItem(historyID: $0.id,
                                           boardDocumentID: $0.boardReference.documentID,
                                           title: $0.board.title,
                                           board: $0.board.makeBoard(),
                                           isStared: staredIds.contains($0.board.id))
                }
            }
            .assign(to: &$histories)
    }
    
    func toggleLike(boardID: String) {
        guard let index = self.allBoards.firstIndex(where: { $0.boardDocumentID == boardID }) else { fatalError() }

        var document = allBoards[index]
        document.stared.toggle()
        allBoards[index] = document

        if document.stared {
            like(boardID: boardID)
        } else {
            unlike(boardID: boardID)
        }
    }
    
    func addToHistory(boardID: String, user: User) {
        historyRepository.get(id: boardID) { document in
            if let document = document {
                document.reference.updateData(["createdAt" : FieldValue.serverTimestamp()])
            } else {
                self.boardRepository.get(by: boardID) {
                    let document = HistoryDocument(boardReference: $0.reference)
                    self.historyRepository.add(by: boardID, document)
                }
            }
        }
    }
    
    // MARK: Private
    
    private func like(boardID: String) {
        boardRepository.get(by: boardID) { [unowned self]  board in
            self.staredRepository.get(id: boardID) { [unowned self] stared in
                if stared == nil {
                    let document = StaredDocument(referenceBoard: board.reference)
                    self.staredRepository.add(id: boardID, document: document)
                }
            }
        }
    }
    
    private func unlike(boardID: String) {
        boardRepository.get(by: boardID) { [unowned self] board in
            self.staredRepository.get(id: boardID) { [unowned self] stared in
                if let stared = stared {
                    self.staredRepository.delete(id: stared.id)
                }
            }
        }
    }
}
