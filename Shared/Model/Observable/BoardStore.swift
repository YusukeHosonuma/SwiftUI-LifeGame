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
    var allBoards: [PatternItem] { get }
    var histories: [BoardHistoryItem] { get }
}

// TODO: 認証あり・なしでバッサリとモデルを分けたほうが良い気もする・・・うーん？

final class BoardStore: BoardStoreProtocol {
    static let shared = BoardStore()
    
    @Published var allBoards: [PatternItem] = []
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
        staredRepository?.publisher.map { Set($0.map(\.id)) }.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
//
//    func addToHistory(boardID: String) {
//        guard let historyRepository = historyRepository else { preconditionFailure("This method is login required.") }
//
//        historyRepository.get(id: boardID) { document in
//            if let document = document {
//                document.reference.updateData(["createdAt" : FieldValue.serverTimestamp()])
//            } else {
//                self.patternRepository.get(by: boardID) {
//                    let document = HistoryDocument(patternDocumentRef: $0.reference)
//                    historyRepository.add(by: boardID, document)
//                }
//            }
//        }
//    }
    
    // MARK: Private
    
//    func toggleLike(to item: BoardItem) {
//        if item.stared {
//            unlike(patternID: item.patternID)
//        } else {
//            like(patternID: item.patternID)
//        }
//    }
//
//    func like(patternID: String) {
//        guard let staredRepository = staredRepository else { preconditionFailure("This method is login required.") }
//
//        let document = StaredDocument(patternID: patternID)
//        staredRepository.setData(document)
//    }
//
//    func unlike(patternID: String) {
//        guard let staredRepository = staredRepository else { preconditionFailure("This method is login required.") }
//
//        staredRepository.delete(id: patternID)
//    }
}
