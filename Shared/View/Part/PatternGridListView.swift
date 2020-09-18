//
//  PatternGridListView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/18.
//

import SwiftUI

extension PatternGridListView {
    enum Style {
        case grid
        case horizontal
    }
}

struct PatternGridListView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var boardStore: BoardStore
    @EnvironmentObject var authentication: Authentication
    
    var style: Style
    @Binding var presented: Bool
    var patternURLs: [URL]
    
    var body: some View {
        switch style {
        case .grid:
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    content()
                }
                .padding(16)
            }
            .padding(-16)
            
        case .horizontal:
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.fixed(100))]) {
                    ForEach(patternURLs, id: \.self) { url in
                        PatternGridLoadView(
                            url: url,
                            isSignIn: authentication.isSignIn,
                            didTap: didTapItem,
                            didToggleStar: didToggleStar
                        )
                        .frame(width: 100) // TODO: タイトルの長さに横幅が伸びてしまうので暫定
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.horizontal, -16)
        }
    }
    
    func content() -> some View {
        ForEach(patternURLs, id: \.self) { url in
            PatternGridLoadView(
                url: url,
                isSignIn: authentication.isSignIn,
                didTap: didTapItem,
                didToggleStar: didToggleStar
            )
        }
    }
    
    // MARK: Action
    
    private func didTapItem(item: BoardItem) {
        if authentication.isSignIn {
            boardStore.addToHistory(boardID: item.boardDocumentID)
        }
        gameManager.setBoard(board: item.board)
        self.presented = false
    }
    
    private func didToggleStar(item: BoardItem) {
        boardStore.toggleLike(to: item)
    }
}
