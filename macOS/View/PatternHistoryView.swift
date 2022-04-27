//
//  PatternHistoryView.swift
//  LifeGameApp (macOS)
//
//  Created by 細沼祐介 on 2020/10/02.
//

import SwiftUI
import Core

struct PatternHistoryView: View {
    @StateObject private var manager: PatternSelectManager = .init()

    var body: some View {
        PatternGridListView(
            style: .horizontal,
            patternURLs: manager.historyURLs,
            didTapItem: didTapItem,
            didToggleStar: didToggleStar
        )
    }
    
    // MARK: Action
    
    private func didTapItem(item: PatternItem) {
        manager.select(item: item)
    }
    
    private func didToggleStar(item: PatternItem) {
        manager.toggleStar(item: item)
    }
}

struct PatternHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        PatternHistoryView()
    }
}
