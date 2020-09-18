//
//  PatternCategoryList.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/09/18.
//

import SwiftUI

struct PatternCategoryListView: View {
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
            PatternGridListView(style: .grid, presented: $presented, patternURLs: patternURLs)
                .padding()
                .navigationTitle(title)
        )
    }
}
