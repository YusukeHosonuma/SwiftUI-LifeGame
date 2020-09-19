//
//  PatternCategoryList.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/09/18.
//

import SwiftUI

struct PatternCategoryListView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var patternStore: PatternStore
    
    @Binding var presented: Bool
    
    var body: some View {
        List {
            Section {
                navigationLink(title: "All", patternURLs: patternStore.allURLs)
            }
            Section(header: Text("Find by type")) {
                ForEach(PatternCategory.allCases) { category in
                    navigationLink(title: category.rawValue, patternURLs: patternStore.urlsByCategory[category] ?? [])
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
    
    private func navigationLink(title: String, patternURLs: [URL]) -> some View {
        NavigationLink(title, destination:
            PatternGridListView(
                style: .grid,
                patternURLs: patternURLs,
                didTapItem: didTapItem,
                didToggleStar: didToggleStar
            )
            .padding()
            .navigationTitle(title)
        )
    }
    
    // MARK: Action
    
    private func didTapItem(item: PatternItem) {
        patternStore.recordHistory(patternID: item.patternID)
        gameManager.setBoard(board: item.board)
        self.presented = false
    }
    
    private func didToggleStar(item: PatternItem) {
        patternStore.toggleStar(item: item)
    }
}
