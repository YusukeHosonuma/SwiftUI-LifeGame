//
//  PatternCategoryList.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/09/18.
//

import SwiftUI

struct PatternCategoryListView: View {
    @EnvironmentObject var gameManager: GameManager

    @ObservedObject var store: PatternStore
    @Binding var presented: Bool
    
    var body: some View {
        List {
            Section {
                navigationLink(title: "All", patternURLs: store.allURLs)
            }
            Section(header: Text("Find by type")) {
                ForEach(PatternCategory.allCases) { category in
                    navigationLink(title: category.rawValue, patternURLs: store.urlsByCategory[category] ?? [])
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
        store.recordHistory(patternID: item.patternID)
        gameManager.setBoard(board: item.board)
        self.presented = false
    }
    
    private func didToggleStar(item: PatternItem) {
        store.toggleStar(item: item)
    }
}
