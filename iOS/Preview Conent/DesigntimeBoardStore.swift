//
//  DesigntimeBoardStore.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/18.
//

import SwiftUI

final class DesigntimeBoardStore: BoardStoreProtocol {
    @Published var allBoards: [BoardItem]
    @Published var histories: [BoardHistoryItem]
    
    init(allBoards: [BoardItem], histories: [BoardHistoryItem]) {
        self.allBoards = allBoards
        self.histories = histories
    }
    
    func toggleLike(boardID: String) {
        if let index = allBoards.firstIndex(where: { $0.id == boardID }) {
            var item = allBoards[index]
            item.stared.toggle()
            allBoards[index] = item
        }
        
        if let index = histories.firstIndex(where: { $0.id == boardID }) {
            var item = histories[index]
            item.isStared.toggle()
            histories[index] = item
        }
    }
    
    func addToHistory(boardID: String) {
    }
}

