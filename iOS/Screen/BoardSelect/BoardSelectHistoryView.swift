//
//  BoardSelectHistoryView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/16.
//

import SwiftUI
import LifeGame

struct BoardSelectHistoryView: View {
    typealias Item = BoardHistoryItem
    
    let items: [Item]
    let toggleStar: (String) -> Void
    let tapItem: (Item) -> Void
    
    var body: some View {
        if items.isEmpty {
            Text("No hitories.").emptyContent()
        } else {
            ScrollView([.horizontal]) {
                LazyHStack(spacing: 16) {
                    ForEach(items) { item in
                        Button(action: { tapItem(item) }) {
                            historyCell(item: item)
                        }
                        .contextMenu {
                            BoardSelectContextMenu(isStared: item.isStared) {
                                toggleStar(item.boardDocumentID)
                            }
                        }
                    }
                }
                .padding([.horizontal, .bottom])
            }
        }
    }
    
    private func historyCell(item: Item) -> some View {
        VStack(alignment: .leading) {
            BoardThumbnailImage(board: item.board, cacheKey: item.id)
            Text(item.title)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .font(.system(.caption, design: .monospaced))
        .frame(width: 80)
    }
}

struct BoardSelectHistoryView_Previews: PreviewProvider {
    typealias Item = BoardHistoryItem
    
    static var previews: some View {
        view(items:  [
            Item(historyID: "0", boardDocumentID: "", title: BoardPreset.nebura.displayText, board: BoardPreset.nebura.board.board, isStared: true),
            Item(historyID: "1", boardDocumentID: "", title: BoardPreset.spaceShip.displayText, board: BoardPreset.spaceShip.board.board, isStared: false),
        ])
        view(items: [])
    }
    
    static func view(items: [Item]) -> some View {
        BoardSelectHistoryView(items: items, toggleStar: { _ in }, tapItem: { _ in })
            .previewLayout(.fixed(width: 370, height: 100))
    }
}
