//
//  PatternCategoryList.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/09/18.
//

import SwiftUI

struct PatternCategoryListView: View {
    @ObservedObject var patternSelectManager: PatternSelectManager
    
    var body: some View {
        List {
            Section {
                navigationLink(title: "All", patternURLs: patternSelectManager.allURLs)
            }
            Section(header: Text("Find by type")) {
                ForEach(PatternCategory.allCases) { category in
                    navigationLink(title: category.rawValue, patternURLs: patternSelectManager.urlsByCategory[category] ?? [])
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
                didTapItem: patternSelectManager.select,
                didToggleStar: patternSelectManager.toggleStar
            )
            .padding()
            .navigationTitle(title)
        )
    }
}
