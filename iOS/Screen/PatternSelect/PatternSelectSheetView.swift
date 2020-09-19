//
//  PatternSelectSheetView.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/09/18.
//

import SwiftUI

struct PatternSelectSheetView: View {
    @StateObject var patternSelectManager: PatternSelectManager

    init(presented: Binding<Bool>) {
        _patternSelectManager = StateObject(wrappedValue: .init(presented: presented))
    }
    
    var body: some View {
        NavigationView {
            TabView {
                PatternCategoryListView(patternSelectManager: patternSelectManager)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Find")
                    }
                MyPatternListView(patternSelectManager: patternSelectManager)
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("My Page")
                    }
            }
            .navigationTitle("Select pattern")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: patternSelectManager.cancel)
                }
            }
        }
    }
}
