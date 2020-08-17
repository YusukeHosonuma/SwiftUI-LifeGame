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
    func addToHistory(boardID: String)
}

// TODO: 認証あり・なしでバッサリとモデルを分けたほうが良い気もする・・・うーん？

final class BoardStore: BoardStoreProtocol {
    static var shared = BoardStore()
    
    @Published var allBoards: [BoardItem] = []
    @Published var histories: [BoardHistoryItem] = []
    
    private let authentication: Authentication = .shared
    private let boardRepository: FirestoreBoardRepository = .shared
    
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

        repositories.history.$items.combineLatest(staredIdsPublisher)
            .map { histories, staredIds in
                histories.map {
                    BoardHistoryItem(historyID: $0.id,
                                     boardDocumentID: $0.boardReference.documentID,
                                     title: $0.board.title,
                                     board: $0.board.makeBoard(),
                                     isStared: staredIds.contains($0.board.id!))
                }
            }
            .assign(to: &$histories)
    }
    
    private func startListenForSignOut() {
        boardRepository.$items
            .map { boards in
                boards.map {
                    BoardItem(boardDocumentID: $0.id!,
                              title: $0.title,
                              board: $0.makeBoard(),
                              stared: false)
                }
            }
            .assign(to: &$allBoards)
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
    
    func addToHistory(boardID: String) {
        guard let historyRepository = historyRepository else { preconditionFailure("This method is login required.") }
        
        historyRepository.get(id: boardID) { document in
            if let document = document {
                document.reference.updateData(["createdAt" : FieldValue.serverTimestamp()])
            } else {
                self.boardRepository.get(by: boardID) {
                    let document = HistoryDocument(boardReference: $0.reference)
                    historyRepository.add(by: boardID, document)
                }
            }
        }
    }
    
    // MARK: Private
    
    private func like(boardID: String) {
        guard let staredRepository = staredRepository else { preconditionFailure("This method is login required.") }
        
        boardRepository.get(by: boardID) { board in
            staredRepository.get(id: boardID) { stared in
                if stared == nil {
                    let document = StaredDocument(referenceBoard: board.reference)
                    staredRepository.add(id: boardID, document: document)
                }
            }
        }
    }
    
    private func unlike(boardID: String) {
        guard let staredRepository = staredRepository else { preconditionFailure("This method is login required.") }

        boardRepository.get(by: boardID) { board in
            staredRepository.get(id: boardID) { stared in
                if let stared = stared {
                    staredRepository.delete(id: stared.id)
                }
            }
        }
    }
}
