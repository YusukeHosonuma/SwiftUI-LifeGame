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
                        historyCell(item: item)
                            .contextMenu {
                                BoardSelectContextMenu(isStared: .init(get: { item.isStared }, set: { _ in
                                    toggleStar(item.boardDocumentID)
                                }))
                            }
                            // Note:
                            // Macでは`Button`を使用するとネイティブのボタンの見た目になってしまうため`.onTapGesture`を利用する必要がある（macOS-beta 5）❗
                            .onTapGesture {
                                tapItem(item)
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
            HStack {
                Text(item.title)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundColor(.accentColor)
                Spacer()
                if item.isStared {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }
        }
        .font(.system(.caption, design: .monospaced))
        .aspectRatio(contentMode: .fit)
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
