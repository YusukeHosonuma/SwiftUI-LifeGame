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
    
    func addToHistory(boardID: String)
}

// TODO: 認証あり・なしでバッサリとモデルを分けたほうが良い気もする・・・うーん？

final class BoardStore: BoardStoreProtocol {
    static let shared = BoardStore()
    
    @Published var allBoards: [BoardItem] = []
    @Published var histories: [BoardHistoryItem] = []
    
    private let authentication: Authentication = .shared
    //private let boardRepository: FirestoreBoardRepository = .shared
    private let patternRepository: FirestorePatternRepository = .shared
    
    private var staredRepository: FirestoreStaredRepository? {
        authentication.repositories?.stared
    }
    
    private var historyRepository: FirestoreHistoryRepository? {
        authentication.repositories?.history
    }
    
    private var staredIdsPublisher: AnyPublisher<Set<String>, Never>? {
        staredRepository?.items.map { Set($0.map(\.id)) }.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    
    init() {
        authentication.$repositories
            .sink {
                if let repositories = $0 {
                    self.startListenForSignIn(repositories: repositories)
                } else {
                    self.startListenForSignOut()
                }
            }
            .store(in: &cancellables)
    }
    
    private func startListenForSignIn(repositories: AuthenticationRepositories) {
        let staredIdsPublisher = repositories.stared.items.map { Set($0.map(\.id)) }
        
        patternRepository.$items.combineLatest(staredIdsPublisher)
            .map { boards, staredIds in
                boards.map {
                    BoardItem(boardDocumentID: $0.documentID,
                              title: $0.title,
                              board: $0.makeBoard(),
                              stared: staredIds.contains($0.documentID))
                }
            }
            .assign(to: &$allBoards)

        repositories.history.$items.combineLatest(staredIdsPublisher)
            .map { histories, staredIds in
                histories.map {
                    BoardHistoryItem(historyID: $0.id,
                                     boardDocumentID: $0.patternDocumentRef.documentID,
                                     title: $0.board.title,
                                     board: $0.board.makeBoard(),
                                     isStared: staredIds.contains($0.board.id))
                }
            }
            .assign(to: &$histories)
    }
    
    private func startListenForSignOut() {
        patternRepository.$items
            .map { boards in
                boards.map {
                    BoardItem(boardDocumentID: $0.documentID,
                              title: $0.title,
                              board: $0.makeBoard(),
                              stared: false)
                }
            }
            .assign(to: &$allBoards)
    }

    func addToHistory(boardID: String) {
        guard let historyRepository = historyRepository else { preconditionFailure("This method is login required.") }
        
        historyRepository.get(id: boardID) { document in
            if let document = document {
                document.reference.updateData(["createdAt" : FieldValue.serverTimestamp()])
            } else {
                self.patternRepository.get(by: boardID) {
                    let document = HistoryDocument(patternDocumentRef: $0.reference)
                    historyRepository.add(by: boardID, document)
                }
            }
        }
    }
    
    // MARK: Private
    
    func toggleLike(to item: BoardItem) {
        if item.stared {
            unlike(patternID: item.boardDocumentID)
        } else {
            like(patternID: item.boardDocumentID)
        }
    }
    
    func like(patternID: String) {
        guard let staredRepository = staredRepository else { preconditionFailure("This method is login required.") }

        let document = StaredDocument(patternID: patternID)
        staredRepository.setData(document)
    }
    
    func unlike(patternID: String) {
        guard let staredRepository = staredRepository else { preconditionFailure("This method is login required.") }
        
        staredRepository.delete(id: patternID)
    }
}
