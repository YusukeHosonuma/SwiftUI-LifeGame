//
//  MyPatternListView.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/09/18.
//

import SwiftUI

struct MyPatternListView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var authentication: Authentication

    @ObservedObject var store: PatternStore
    @Binding var presented: Bool
    
    var body: some View {
        if authentication.isSignIn {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(alignment: .leading) {
                        title("History")
                        PatternGridListView(
                            style: .horizontal,
                            patternURLs: store.historyURLs,
                            didTapItem: didTapItem,
                            didToggleStar: didToggleStar
                        )
                        .padding(.horizontal)
                        .frame(height: 120)
                    }
                    
                    VStack(alignment: .leading) {
                        title("Stared")
                        PatternGridListView(
                            style: .grid,
                            patternURLs: store.staredURLs,
                            didTapItem: didTapItem,
                            didToggleStar: didToggleStar
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        } else {
            Text("Login is needed.")
        }
    }
    
    private func title(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .padding([.leading, .top])
    }
    
    // MARK: Action
    
    private func didTapItem(item: PatternItem) {
        store.recordHistory(patternID: item.patternID)
        gameManager.setBoard(board: item.board)
        self.presented = false
    }
    
    private func didToggleStar(item: PatternItem) {
        store.toggleStar(item: item)
    }
}
