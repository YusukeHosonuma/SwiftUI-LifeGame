//
//  PatternSelectSheetView.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/09/18.
//

import SwiftUI

struct PatternSelectSheetView: View {
    @EnvironmentObject var patternStore: PatternStore
    @Binding var presented: Bool

    var body: some View {
        NavigationView {
            TabView {
                PatternCategoryListView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Find")
                    }
                MyPatternListView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("My Page")
                    }
            }
            .navigationTitle("Select pattern")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: tapCancel)
                }
            }
        }
    }
    
    // MARK: Actions

    private func tapCancel() {
        presented = false
    }
}
