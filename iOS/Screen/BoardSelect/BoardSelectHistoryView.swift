//
//  BoardSelectHistoryView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/16.
//

import SwiftUI
import LifeGame

struct BoardSelectHistoryItem: Identifiable {
    var id: String { historyID }
    var historyID: String
    var boardID: String
    var title: String
    var board: Board<Cell>
    var isStared: Bool
}

struct BoardSelectHistoryView: View {
    typealias Item = BoardSelectHistoryItem
    
    let isSignIn: Bool
    let items: [Item]
    let toggleStar: (String) -> Void
    let tapItem: (Item) -> Void
    
    var body: some View {
        if isSignIn {
            if items.isEmpty {
                Text("No hitories.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ScrollView([.horizontal]) {
                    LazyHStack(spacing: 16) {
                        ForEach(items) { item in
                            Button(action: { tapItem(item) }) {
                                historyCell(item: item)
                            }
                            .contextMenu {
                                BoardSelectContextMenu(isStared: item.isStared) {
                                    toggleStar(item.boardID)
                                }
                            }
                        }
                    }
                    .padding([.horizontal, .bottom])
                }
            }
        } else {
            Text("Need login.")
                .foregroundColor(.secondary)
                .padding()
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
    typealias Item = BoardSelectHistoryItem
    
    static var previews: some View {
        view(isSignIn: true, items:  [
            Item(historyID: "0", boardID: "", title: BoardPreset.nebura.displayText, board: BoardPreset.nebura.board.board, isStared: true),
            Item(historyID: "1", boardID: "", title: BoardPreset.spaceShip.displayText, board: BoardPreset.spaceShip.board.board, isStared: false),
        ])
        view(isSignIn: true, items: [])
        view(isSignIn: false, items: [])
    }
    
    static func view(isSignIn: Bool, items: [Item]) -> some View {
        BoardSelectHistoryView(isSignIn: isSignIn, items: items, toggleStar: { _ in }, tapItem: { _ in })
            .previewLayout(.fixed(width: 370, height: 100))
    }
}
