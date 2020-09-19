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
    @EnvironmentObject var patternStore: PatternStore

    var body: some View {
        if authentication.isSignIn {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(alignment: .leading) {
                        title("History")
                        PatternGridListView(
                            style: .horizontal,
                            patternURLs: patternStore.historyURLs,
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
                            patternURLs: patternStore.staredURLs,
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
        gameManager.setPattern(item)
    }
    
    private func didToggleStar(item: PatternItem) {
        patternStore.toggleStar(item: item)
    }
}
